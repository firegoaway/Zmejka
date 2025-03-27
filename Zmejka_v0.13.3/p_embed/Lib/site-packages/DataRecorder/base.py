# -*- coding:utf-8 -*-
from abc import abstractmethod
from pathlib import Path
from threading import Lock
from time import sleep

from .setter import OriginalSetter, BaseSetter
from .tools import get_usable_path, make_valid_name


class OriginalRecorder(object):
    """记录器的基类"""
    _SUPPORTS = ('any',)

    def __init__(self, path=None, cache_size=None):
        """
        :param path: 保存的文件路径
        :param cache_size: 每接收多少条记录写入文件，0为不自动写入
        """
        self._data = None
        self._style_data = None
        self._path = None
        self._type = None
        self._lock = Lock()
        self._pause_add = False  # 文件写入时暂停接收输入
        self._pause_write = False  # 标记文件正在被一个线程写入
        self.show_msg = True
        self._setter = None
        self._data_count = 0  # 已缓存数据的条数
        self._file_exists = False
        self._backup_path = 'backup'
        self._backup_times = 0  # 自动保存次数
        self._backup_interval = 0
        self._backup_new_name = True

        if path:
            self.set.path(path)
        self._cache = cache_size if cache_size is not None else 1000

    def __del__(self):
        """对象关闭时把剩下的数据写入文件"""
        self.record()

    @property
    def set(self):
        """返回用于设置属性的对象"""
        if self._setter is None:
            self._setter = OriginalSetter(self)
        return self._setter

    @property
    def cache_size(self):
        """返回缓存大小"""
        return self._cache

    @property
    def path(self):
        """返回文件路径"""
        return self._path

    @property
    def type(self):
        """返回文件类型"""
        return self._type

    @property
    def data(self):
        """返回当前保存在缓存的数据"""
        return self._data

    def record(self):
        """记录数据，返回文件路径"""
        if not self._data and not self._style_data:
            return self._path

        if not self._path:
            raise ValueError('保存路径为空。')

        with self._lock:
            if self._backup_interval and self._backup_times >= self._backup_interval:
                if self._backup_new_name:
                    from datetime import datetime
                    name = Path(self._path)
                    name = f'{Path(self._path).stem}_{datetime.now().strftime("%Y%m%d%H%M%S")}{name.suffix}'
                    name = get_usable_path(Path(self._backup_path) / name).name
                else:
                    name = None
                self.backup(path=self._backup_path, name=name)

            self._pause_add = True  # 写入文件前暂缓接收数据
            if self.show_msg:
                print(f'{self.path} 开始写入文件，切勿关闭进程。')

            Path(self.path).parent.mkdir(parents=True, exist_ok=True)
            while True:
                try:
                    while self._pause_write:  # 等待其它线程写入结束
                        sleep(.1)

                    self._pause_write = True
                    self._record()
                    break

                except PermissionError:
                    if self.show_msg:
                        print('\r文件被打开，保存失败，请关闭，程序会自动重试。', end='')

                except Exception as e:
                    try:
                        with open('failed_data.txt', 'a+', encoding='utf-8') as f:
                            f.write(str(self.data) + '\n')
                        print('保存失败的数据已保存到failed_data.txt。')
                    except:
                        raise e
                    raise

                finally:
                    self._pause_write = False

                sleep(.3)

            if self.show_msg:
                print(f'{self.path} 写入文件结束。')
            self.clear()
            self._data_count = 0
            self._pause_add = False

        if self._backup_interval:
            self._backup_times += 1
        return self._path

    def clear(self):
        """清空缓存中的数据"""
        if self._data:
            self._data.clear()

    def backup(self, path='backup', name=None):
        """把当前文件备份到指定路径
        :param path: 文件夹路径
        :param name: 保存的文件名，为None使用记录目标指定的文件名
        """
        if not self._file_exists:
            return

        path = Path(path)
        path.mkdir(parents=True, exist_ok=True)
        src_path = Path(self._path)
        if not name:
            name = src_path.name
        elif not name.endswith(src_path.suffix):
            name = f'{name}{src_path.suffix}'
        path = path / make_valid_name(name)

        from shutil import copy
        copy(self._path, path)
        self._backup_times = 0

    @abstractmethod
    def add_data(self, data):
        pass

    @abstractmethod
    def _record(self):
        pass


class BaseRecorder(OriginalRecorder):
    """Recorder、Filler和DBRecorder的父类"""
    _SUPPORTS = ('xlsx', 'csv')

    def __init__(self, path=None, cache_size=None):
        """
        :param path: 保存的文件路径
        :param cache_size: 每接收多少条记录写入文件，0为不自动写入
        """
        super().__init__(path, cache_size)
        self._before = []
        self._after = []
        self._encoding = 'utf-8'
        self._table = None

    @property
    def set(self):
        """返回用于设置属性的对象"""
        if self._setter is None:
            self._setter = BaseSetter(self)
        return self._setter

    @property
    def before(self):
        """返回当前before内容"""
        return self._before

    @property
    def after(self):
        """返回当前after内容"""
        return self._after

    @property
    def table(self):
        """返回默认表名"""
        return self._table

    @property
    def encoding(self):
        """返回编码格式"""
        return self._encoding

    @abstractmethod
    def add_data(self, data, table=None):
        pass

    @abstractmethod
    def _record(self):
        pass
