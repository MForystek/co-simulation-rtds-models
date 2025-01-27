import sys
import struct
import logging
import time
import socketserver

_log = logging.getLogger()
logging.basicConfig(level=logging.INFO,
                    format="%(asctime)s.%(msecs)03d | %(levelname)s | %(message)s",
                    datefmt="%m/%d/%Y %H:%M:%S",
                    handlers=[
                        logging.StreamHandler(sys.stdout),
                        logging.FileHandler("log.txt", mode="w+", encoding="UTF-8")],
                    force=True)


class MyHandler(socketserver.BaseRequestHandler):
    def setup(self):
        _log.info("Setup...")
        self.filename = "delay_comp.txt"
        
    def handle(self):
        _log.info("Handling...")
        with open(self.filename, "a+") as file:
            now = time.time_ns()
            data = self.request.recv(24).strip() # 6 floats * 4 bytes
            unpacked_data = struct.unpack("%f, %f, %f, %f, %f, %f,", data)
            file.write(f"{now}, {unpacked_data}")


if __name__ == "__main__":
    _log.info("Starting TCP server")
    
    measurement_time = 60 # sec
    timestep = 0.01 # sec
    steps = measurement_time / timestep

    GTNetIP = "172.24.14.221"
    local_ip = "172.24.14.98"
    port = 7777

    with socketserver.TCPServer(("localhost", port), MyHandler) as server:
        _log.info("Listening...")
        server.serve_forever()
        # for i in range(int(steps)):
        #     server.handle_request()
        #     _log.info(f"Handled request no. {i}")
        # _log.info("Done")