"""
 Simple JSON-RPC Server

"""

import functions
import json
import socket


class JSONRPCServer:
    """The JSON-RPC server."""

    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.sock = None
        self.funcs = {}

    def register(self, name, function):
        """Registers a function."""
        self.funcs[name] = function
        return function

    def start(self):
        """Starts the server."""
        self.sock = socket.socket()
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind((self.host, self.port))
        self.sock.listen(1)
        print('Listening on port %s ...' % self.port)

        try:
            while True:
                # Accepts and handles client
                conn, _ = self.sock.accept()
                self.handle_client(conn)

                # Close client connection
                conn.close()

        except ConnectionAbortedError:
            pass
        except OSError:
            pass

    def stop(self):
        """Stops the server."""
        self.sock.close()

    def handle_client(self, conn):
        """Handles the client connection."""

        # Receive message
        msg = conn.recv(1024).decode()
        print('Received:', msg)  # str
        try:
            msg = json.loads(msg)  # dict
        except json.JSONDecodeError:
            print("This is invalid json")
        else:
            print("This is valid json")

        if msg['method'] == 'hello':
            result = functions.hello()
        elif msg['method'] == 'greet' and isinstance('params', str):
            values = msg['params']
            name = values[0]
            result = functions.greet(name)
        elif msg['method'] == 'square' or len(msg['method']) == 10:
            values = msg['params']
            a = int(values[0])
            function = self.funcs[msg["method"]]
            result = function(a)
        elif msg['method'] == 'add' or 'sub' or 'div' or 'mul':
            values = msg['params']
            b = int(values[0])
            c = int(values[1])
            function = self.funcs[msg["method"]]
            result = function(b, c)

        res = {
            'id': 1,
            'jsonrpc': '2.0',
            "result": result
        }
        res.update({"id": msg["id"]})
        # Send response
        res = json.dumps(res)
        conn.send(res.encode())


if __name__ == "__main__":
    # Test the JSONRPCServer class
    server = JSONRPCServer('0.0.0.0', 8000)

    # Register functions
    server.register('hello', functions.hello)
    server.register('greet', functions.greet)
    server.register('add', functions.add)
    server.register('sub', functions.sub)
    server.register('mul', functions.mul)
    server.register('div', functions.div)
    server.register('square', functions.square)
    server.register('random_function', functions.random_function)

    # Start the server
    server.start()
