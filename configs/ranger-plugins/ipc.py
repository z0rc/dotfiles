import os
import ranger.api


HOOK_INIT_OLD = ranger.api.hook_init


def hook_init(fm):
    try:
        if not os.path.isdir(os.getenv("XDG_RUNTIME_DIR")):
            os.makedirs(os.getenv("XDG_RUNTIME_DIR"))
        ipc_fifo = os.path.join(os.getenv("XDG_RUNTIME_DIR"),
                                "ranger-ipc." + str(os.getpid()))
        os.mkfifo(ipc_fifo)

        try:
            import thread
        except ImportError:
            import _thread as thread

        def ipc_reader(filepath):
            while True:
                with open(filepath, 'r') as fifo:
                    line = fifo.read()
                    fm.execute_console(line.strip())
        thread.start_new_thread(ipc_reader, (ipc_fifo,))

        def ipc_cleanup(filepath):
            try:
                os.unlink(filepath)
            except IOError:
                pass
        import atexit
        atexit.register(ipc_cleanup, ipc_fifo)
    except IOError:
        pass
    finally:
        HOOK_INIT_OLD(fm)


ranger.api.hook_init = hook_init
