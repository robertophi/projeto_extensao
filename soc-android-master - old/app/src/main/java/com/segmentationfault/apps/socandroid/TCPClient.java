package com.segmentationfault.apps.socandroid;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.Socket;
import java.nio.ByteBuffer;

/**
 * Created by nakayama on 7/12/16.
 */
//Must be used inside a Thread otherwise Android OS will stop the application
public class TCPClient {
    private static String ip = "192.168.15.252";
    private static int port = 5000;

    /*
    *
    * */
    public static byte[] send(final byte[] bytes) {
        return send(bytes, false);
    }

    public static byte[] send(final byte[] bytes, boolean read)
    {
        byte [] rcv = null;
        try {
            Socket socket;
            PrintWriter out;
            String data;

            // Starts TCP socket
            socket = new Socket(TCPClient.ip, TCPClient.port);
            socket.setSendBufferSize(bytes.length);
            socket.setSoTimeout(10000);

            data = new String(bytes, "UTF_8");
            out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(socket.getOutputStream())), true);
            out.println(data);

            if(read) {
                BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                rcv = in.readLine().getBytes();
            }

            socket.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return rcv;
    }

    public static int getPort() {
        return port;
    }

    public static String getIp() {
        return ip;
    }

    public static void setIp(String ip) {
        TCPClient.ip = ip;
    }

    public static void setPort(int port) {
        TCPClient.port = port;
    }
}
