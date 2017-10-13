#! /usr/bin/env python

import os
import logging
import json
import time
import collections

from operator import itemgetter
from operator import add
from functools import partial
from functools import reduce


ENV_NAME = 'TARGET_DIRECTORY'

LOGGER = logging.getLogger('reaper')
LOGGER.addHandler(logging.StreamHandler())
LOGGER.setLevel(logging.INFO)


def _consume(iterator):
    collections.deque(iterator, maxlen=0)


def _apply_in_order(functions, input_data):
    """ Helper to pass data through multiple functions
        e.g. _apply_in_order((int, partial(add, 1), str), '5') => '6'
    """
    return reduce(lambda res, func: func(res), functions, input_data)


def _json_from_file(path):
    with open(path, 'r') as json_file:
        return json.load(json_file)


def _is_metadata(name):
    return name.endswith('.metadata')


def _is_expired(meta):
    return time.time() > meta.get('exp_time', 0)


def _rm_file(path):
    try:
        os.remove(path)
        LOGGER.info('Removed file: %s', path)
    except OSError:
        LOGGER.exception('Cannot remove file: %s', path)


def _reap_expired(basepath):
    LOGGER.info('Found expired: %s', basepath)
    files = map(partial(add, basepath), ('.metadata', '.done', '.zip'))
    _consume(map(_rm_file, files))


def reap(target):
    LOGGER.info('Running in %s!', target)

    _parent_join = partial(os.path.join, target)

    join_path = partial(map, _parent_join)
    select_metadata = partial(filter, _is_metadata)
    read_json = partial(map, _json_from_file)
    select_expired = partial(filter, _is_expired)
    read_hash = partial(map, itemgetter('hash'))
    remove_expired = partial(map, _reap_expired)

    order = (
        join_path,        # => [/path/to/dir/hash.{zip,done,metadata}]
        select_metadata,  # => [.metadata files]
        read_json,        # => [{'exp_time': ..., 'hash': ...}]
        select_expired,   # => [{'exp_time': in the past, ...}]
        read_hash,        # => [hash, ...]
        join_path,        # => [/path/to/dir/hash]
    )

    expired = tuple(_apply_in_order(order, os.listdir(target)))
    if expired:
        LOGGER.info('Found %s expired hashes!', len(expired))
        _consume(remove_expired(expired))
    else:
        LOGGER.info('No expired hashes found!')


if __name__ == '__main__':
    target = os.environ.get(ENV_NAME)

    if not target:
        LOGGER.error('%s env is required!', ENV_NAME)

    elif not os.path.isdir(target):
        LOGGER.error('Path does not exist or is not a directory: %s', target)

    else:
        reap(target)
