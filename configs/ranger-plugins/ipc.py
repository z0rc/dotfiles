import atexit
import os
try:
    import thread  # type: ignore
except ImportError:
    import _thread as thread
import ranger.api  # type: ignore


HOOK_INIT_OLD = ranger.api.hook_init


def ipc_reader(fm, filepath):
    while True:
        try:
            with open(filepath, 'r') as fifo:
                line = fifo.read()
                if line:
                    fm.execute_console(line.strip())
        except (IOError, OSError):
            return


def ipc_cleanup(filepath):
    try:
        os.unlink(filepath)
    except (IOError, OSError):
        pass


def hook_init(fm):
    HOOK_INIT_OLD(fm)

    xdg_runtime_dir = os.getenv("XDG_RUNTIME_DIR")
    if not xdg_runtime_dir:
        return

    ipc_fifo = os.path.join(xdg_runtime_dir, "ranger-ipc." + str(os.getpid()))

    try:
        os.mkfifo(ipc_fifo)
    except OSError:
        return

    thread.start_new_thread(ipc_reader, (fm, ipc_fifo,))
    atexit.register(ipc_cleanup, ipc_fifo)


ranger.api.hook_init = hook_init
