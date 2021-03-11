"""
 Simple multi-threaded socket server
"""

import socket
import threading


class Server:
    """The chat server."""

    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.sock = None
        self.commandlist = {
            "/username": (1, "Register Username: /username [USER]"),
            "/room": (2, "List current room: /room"),
            "/create": (3, "Create room: /create #[ROOM]"),
            "/rooms": (4, "List rooms: /rooms"),
            "/join": (5, "Enter room: /join #[ROOM]"),
            "/users": (6, "List users in current room: /users"),
            "/msgs": (7, "Send message to room: /msgs [MESSAGE]"),
            "/exit": (8, "User quits: /exit"),
            "/pmsgs": (9, "User send a private msg to another user: /pmsgs [USER] [MESSAGE]"),
            "/allusers": (11, "List all online users: /allusers"),
            "/help": (10, "Help menu: /help")
        }
        self.users = []
        self.rooms = {"#welcome": []}

    def validateCommand(self, msg):
        command = msg.strip().split()
        # Check if it's a command
        if command[0] not in self.commandlist.keys():
            res = "Unknown command."
            return res
        if command[0] == "/username":
            res = self.authUser(command[1])
            self.users.append(command[1])
            return res
        elif command[0] == "/room":
            res = self.isInRoom()
            return res
        elif command[0] == "/create":
            res = self.createRoom(command[1])
            return res
        elif command[0] == "/rooms":
            res = self.getRooms()
            return res
        elif command[0] == "/join":
            res = self.joinRoom(command[1])
            return res
        elif command[0] == "/users":
            res = self.getUsers()
            return res
        elif command[0] == "/msgs":
            res = self.sendRoomMessage(command[1], command[2])
            return res
        elif command[0] == "/pmsgs":
            res = self.sendPrivateMessage(command[1], command[2])
            return res
        elif command[0] == "/allusers":
            res = self.getAllValues()
            return res
        elif command[0] == "/exit":
            res = self.exit()
            return res
        elif command[0] == "/help":
            res = self.help()
            return res

    def start(self):
        """Starts the server."""
        self.sock = socket.socket()
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind((self.host, self.port))
        self.sock.listen(1)
        print('Listening on port %s ...' % self.port)

        try:
            while True:
                # Accept client connections
                conn, _ = self.sock.accept()

                # Starts client thread
                thread = threading.Thread(target=self.handle_client, args=(conn,))
                thread.start()

        except ConnectionAbortedError:
            pass
        except OSError:
            pass

    def stop(self):
        """Stops the server."""
        self.sock.close()

    def authUser(self, username):
        msg = ""
        if not username:
            msg += "/username required"
        elif username in self.users:
            msg += "/username taken"
        else:
            msg += "/username ok"
            self.rooms['#welcome'] += [username]
        return msg

    def joinRoom(self, roomName):
        msg = ""
        if roomName in self.rooms.keys():
            for user in self.rooms.values():
                self.rooms[roomName] += [user]
            msg += "/join ok"
        else:
            msg += "/join no_room"
        return msg

    def createRoom(self, roomName):
        msg = ""
        if roomName in self.rooms.keys():
            msg += "/create room_exists"
        else:
            self.rooms.update({roomName: []})
            msg += "/create ok"
        return msg

    def isInRoom(self):
        tempList = []
        msg = "/room "
        for key, values in self.rooms.items():
            if values in self.rooms.values():
                tempList.append(key)
                for i in tempList:
                    msg += "".join(i)
            else:
                msg += "Not in room"
            return msg

    def getRooms(self):
        roomList = "/rooms"
        for key in self.getAllKeys():
            roomList += " " + key
        return roomList

    def getUsers(self):
        tempList = []
        msg = "/users "
        for key, values in self.rooms.items():
            if key in self.rooms.keys():
                tempList.append(values)
                for i in tempList:
                    msg += " ".join(i)
            return msg

    def sendPrivateMessage(self, receiver, usermsg):
        msg = ""
        if receiver in self.rooms.values():
            msg += "(" + receiver + " @private)" + usermsg
        return msg

    def sendRoomMessage(self, sender, usermsg):
        msg = ""
        if sender in self.rooms.values():
            msg += "(" + sender + self.isInRoom() + ")" + usermsg
        return msg

    def getAllValues(self):
        return self.rooms.values()

    def getAllKeys(self):
        return self.rooms.keys()

    def help(self):
        cmdlist = "Available Commands:"
        for k, v in self.commandlist.values():
            cmdlist += "\n" + v
        return cmdlist

    def exit(self):
        return "/exit ok"

    def handle_client(self, conn):
        """Handles the client connection."""

        while True:
            # Receive message
            msg = conn.recv(1024).decode()
            res = self.validateCommand(msg)

            print(res)

            # Send response
            conn.sendall(res.encode())

            if msg == '/exit':
                break

        # Close client connection
        print('Client disconnected...')
        conn.close()


if __name__ == "__main__":
    # Starts the server
    server = Server('0.0.0.0', 8000)
    server.start()
