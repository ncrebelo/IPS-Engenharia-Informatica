"""
 Simple socket client
"""

import socket
import threading


class Client:
    """The chat client."""

    def __init__(self, host, port):
        self.sock = socket.socket()
        self.sock.connect((host, port))

    def command(self, msg):
        """Sends a command and returns response"""
        if msg == 'exit' or msg == "/exit":
            self.close()
        else:
            self.sock.sendall(msg.encode())
            return self.sock.recv(1024).decode()

    def close(self):
        """Closes the connection."""
        self.sock.close()

    def start(self):
        """Start the command loop."""

        while True:
            # Sends a command
            msg = input('> ')
            res = self.command(msg)
            print(res)

            # Check for termination
            if msg == '/exit ok':
                break

        # Close socket
        self.close()


if __name__ == "__main__":
    # Starts the client
    client = Client('127.0.0.1', 8000)

    print("Username?")
    name = input('> ')
    checkname = client.command(name)

    client.start()

    thread = threading.Thread(target=client.start, args=())
    thread.start()
