from PIL import Image, ImageDraw, ImageFont
import socket
import threading
import pygtk
import struct
import cv2

bind_ip = '0.0.0.0'
bind_port = 5000
width = 64
height = 64

img = Image.new( 'RGB', (width, height), "black") # create a new black image
pixels = img.load() # create the pixel map

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((bind_ip, bind_port))
server.listen(1)

def draw_img(byte_array):
    print(len(byte_array))

    for i in range(img.size[0]):    # for every pixel:
        for j in range(img.size[1]):
            pixels[i,j] = (ord(byte_array[i*width + j]),
                            ord(byte_array[i*width + j + 1]),
                            ord(byte_array[i*width + j + 2]))
            pixels[i,j] = (ord(byte_array[i*width + j]), 0, 0)

    img.show()

def handle_client(client_socket):
    request = client_socket.recv(5)
    result = []

    if request[0] == 'v':
        n = struct.unpack(">L", "".join(request[1:]))[0]
        print(n)

        request = client_socket.recv(n)
        result += request

        while len(result) < n:
            request = client_socket.recv(n - len(result))
            result += request

        if len(result) > n:
            result = request[:n]

        draw_img(result)

    client_socket.close()

if __name__ == "__main__":
    while True:
        client, addr = server.accept()
        client_handler = threading.Thread(target=handle_client, args=(client,))
        client_handler.start()


