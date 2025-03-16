import osqp
import Pyro5.api


@Pyro5.api.expose
class RemoteService:
    def echo(self, message):
        return f"Server received: {message}"

if __name__ == "__main__":
    daemon = Pyro5.api.Daemon(host="192.168.1.100")
    uri = daemon.register(RemoteService)
    print("Ready. Object URI:", uri)
    # Keep the server running to listen for incoming requests.
    daemon.requestLoop()
