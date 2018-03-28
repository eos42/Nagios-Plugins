import argparse
import requests
import sys
import time
import random
import statistics


class NetworkStats(object):

    def __init__(self):
        self.HEAD_BLOCK_INTS = []
        self.URLS = {
                    'get_info': 'http://{host}/v1/chain/get_info'
                    }

        self.cutoff=0.5
        self.delay=2


    def read_head_block_ints(self,hosts):
        for host in hosts:
            try:
                data = requests.get(self.URLS['get_info'].format(host=host), verify=False).json()  # returns data in JSON format
                self.HEAD_BLOCK_INTS.append(float(data['head_block_num']))   # this is the head_block INT
            except:
                print('Error cannot connect to host {host}'.format(host=host))


    def compute_average(self):
        head_block_int_count = len(self.HEAD_BLOCK_INTS)
        median = statistics.median(self.HEAD_BLOCK_INTS)
        random_head_block_indexes = []
        random_head_block_ints = []
        if head_block_int_count > 12:
            for x in range(12):
                next = False
                while not next:
                    rand_index = random.randint(0, head_block_int_count-1)
                    rand_index_exists = False
                    for addedIndexes in random_head_block_indexes:
                        if random == addedIndexes:
                            rand_index_exists = True
                            break;
                    if rand_index_exists == False:
                        # check if this is outlier
                        if abs(median - self.HEAD_BLOCK_INTS[rand_index]) > 1000000: # case of outlier
                            continue
                        else:   # Value well within range
                            random_head_block_indexes.append(rand_index)
                            random_head_block_ints.append(self.HEAD_BLOCK_INTS[rand_index])
                            next = True
        else:
            random_head_block_ints = self.HEAD_BLOCK_INTS
        AVERAGE_RAND_HEAD_BLOCKS_INT = statistics.mean(random_head_block_ints) # computing average
        data = requests.get(self.URLS['get_info'].format(host=self.host), verify=False).json()  # returns data in JSON format
        my_head_block_num = float(data['head_block_num'])
        diff = my_head_block_num - AVERAGE_RAND_HEAD_BLOCKS_INT;
        if abs(diff) > 5:
            return (2, 'Head block number difference out of bounds ({abs_val} INT difference)'.format(abs_val=diff));
        else:
            return (0, 'OK')

    def check_head_average_comparison(self,hosts):

        self.read_head_block_ints(hosts)
        return self.compute_average()

    def check_ratio(self,hosts):
        for host in hosts:
            data = requests.get(self.URLS['get_info'].format(host=host), verify=False).json() # returns data in JSON format
            rate = float(data['participation_rate'])
            if rate >= self.cutoff:
                return (0, 'OK')
            return (2, 'Participation is less than {}'.format(self.cutoff))


    def check_head_has_incremented(self,hosts):
        for host in hosts:
            url = self.URLS['get_info'].format(host=host)
            fst = requests.get(url, verify=False).json()
            time.sleep(self.delay)
            snd = requests.get(url, verify=False).json()
            if int(snd['head_block_num']) > int(fst['head_block_num']):
                return (0, 'OK')
            return (2, 'Head block number not incremented after delay')


class CustomParser(argparse.ArgumentParser):
    def convert_arg_line_to_args(self, arg_line):
        return arg_line.split(" ")

class MainParser():

    def __init__(self):

        self.netStat = NetworkStats()

        self.ALLOWED_FUNCTIONS = {
            'check_ratio': self.netStat.check_ratio,
            'check_head': self.netStat.check_head_has_incremented,
            'check_head_num' : self.netStat.check_head_average_comparison
        }

        self.parser = CustomParser()
        self.parser.fromfile_prefix_chars = '@'
        self.parser.description = 'chain info checker'
        self.parser.add_argument('-n',nargs='+',  help='nodes',type=str)
        self.parser.add_argument('-f', help='check to run',type=str, choices=self.ALLOWED_FUNCTIONS)


if __name__ == '__main__':
    myParser = MainParser()
    args = myParser.parser.parse_args(['-n', '62.210.177.140:8888 54.38.79.109:8888', '@hostconfig.ini'])
    func = myParser.ALLOWED_FUNCTIONS[args.f]
    print(args.f)
    print(args.n)
    try:
        exit_code, message = func(args.n)
    except requests.exceptions.RequestException:
        exit_code, message = (2, 'Error cannot connect to host ' + myParser.netStat.URLS['get_info'].format(host=args.n))
    except Exception as e:
        exit_code, message = (2, e.args[0])

    print(message)
    sys.exit(exit_code)
