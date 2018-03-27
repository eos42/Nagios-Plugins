import argparse
import requests
import sys
import time
import random
import statistics

URLS = {
    'get_info': 'http://{host}/v1/chain/get_info'
}

HOSTS = ['62.210.177.140:8888','54.38.79.109:8888','test.eosys.io:8888','ctestnet.eosio.se:8889','138.68.238.129:8888','superhero-api.tokenika.io:8888','203.59.26.145:8888']

HEAD_BLOCK_INTS = [

]


def read_head_block_ints():
    for host in HOSTS:
        try:
            data = requests.get(URLS['get_info'].format(host=host), verify=False).json()  # returns data in JSON format
            HEAD_BLOCK_INTS.append(float(data['head_block_num']))   # this is the head_block INT
        except:
            print('Error cannot connect to host {host}'.format(host=host))


def compute_average(host):
    head_block_int_count = len(HEAD_BLOCK_INTS)
    median = statistics.median(HEAD_BLOCK_INTS)
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
                    if abs(median - HEAD_BLOCK_INTS[rand_index]) > 1000: # case of outlier
                        continue
                    else:   # Value well within range
                        random_head_block_indexes.append(rand_index)
                        random_head_block_ints.append(HEAD_BLOCK_INTS[rand_index])
                        next = True
    else:
        random_head_block_ints = HEAD_BLOCK_INTS
    AVERAGE_RAND_HEAD_BLOCKS_INT = statistics.mean(random_head_block_ints) # computing average
    data = requests.get(URLS['get_info'].format(host=host), verify=False).json()  # returns data in JSON format
    my_head_block_num = float(data['head_block_num'])
    diff = my_head_block_num - AVERAGE_RAND_HEAD_BLOCKS_INT;
    if abs(diff) > 5:
        return (2, 'Head block number difference out of bounds ({abs_val} INT difference)'.format(abs_val=diff));
    else:
        return (0, 'OK')


def check_head_average_comparison(host):
    read_head_block_ints()
    return compute_average(host)


def check_ratio(host, cutoff=0.5):
    data = requests.get(URLS['get_info'].format(host=host), verify=False).json() # returns data in JSON format
    rate = float(data['participation_rate'])
    if rate >= cutoff:
        return (0, 'OK')
    return (2, 'Participation is less than {}'.format(cutoff))


def check_head_has_incremented(host, delay=2):
    url = URLS['get_info'].format(host=host)
    fst = requests.get(url, verify=False).json()
    time.sleep(delay)
    snd = requests.get(url, verify=False).json()
    if int(snd['head_block_num']) > int(fst['head_block_num']):
        return (0, 'OK')
    return (2, 'Head block number not incremented after delay')


ALLOWED_FUNCTIONS = {
    'check_ratio': check_ratio,
    'check_head': check_head_has_incremented,
    'check_fork' : check_head_average_comparison
}

parser = argparse.ArgumentParser(description='chain info checker')
parser.add_argument('host', help='host address')
parser.add_argument('function', help='check to run', choices=ALLOWED_FUNCTIONS)



if __name__ == '__main__':
    args = parser.parse_args()

    func = ALLOWED_FUNCTIONS[args.function]
    try:
        exit_code, message = func(args.host)
    except requests.exceptions.RequestException:
        exit_code, message = (2, 'Error cannot connect to host ' + URLS['get_info'].format(host=args.host))
    except Exception as e:
        exit_code, message = (2, e.args[0])

    print(message)
    sys.exit(exit_code)
