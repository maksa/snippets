package main

import (
	"bufio"
	"flag"
	"fmt"
	"io/ioutil"
	"net"
	"os"
	"time"
)

var trafficfolder = ""

func main() {
	lparam := flag.String("l", "localhost:6487", "Listener address:port")
	oparam := flag.String("o", "elsewhere.com:6487", "Outgoing address:port")
	fparam := flag.String("f", ".", "traffic folder")
	flag.Parse()
	fmt.Println(*lparam)
	fmt.Println(*fparam)
	fmt.Println(*oparam)
	trafficfolder = *fparam

	clientToServerChannel := make(chan []byte)
	serverToClientChannel := make(chan []byte)

	go startRemote(*oparam, clientToServerChannel, serverToClientChannel)
	go startLocal(*lparam, clientToServerChannel, serverToClientChannel)

	for {
		time.Sleep(time.Second * 5)
	}
}

func startLocal(address string, clientToServerChannel chan []byte, serverToClientChannel chan []byte) {
	fmt.Println("starting local")
	listener, error := net.Listen("tcp", address)
	if error == nil {
		fmt.Println("listening on: " + address)
	}

	con, _ := listener.Accept()
	fmt.Println("accepted")
	go handleConnection(con, clientToServerChannel, serverToClientChannel)

}

func handleConnection(con net.Conn, clientToServerChannel chan []byte, serverToClientChannel chan []byte) {

	go func() {
		counter := 0
		for {
			buff := make([]byte, 4096)
			readbytes, err := con.Read(buff)
			if err != nil {
				fmt.Println("client disconnected")
				os.Exit(0)
			}
			if readbytes <= 0 {
				continue
			}
			filename := fmt.Sprintf("%s//%d.req", trafficfolder, counter)
			err = ioutil.WriteFile(filename, buff[0:readbytes], 0644)
			if err != nil {
				panic(err)
			}
			fmt.Printf("read %d bytes from client\n", readbytes)
			counter = counter + 1
			if err != nil {
				panic(err)
			}
			clientToServerChannel <- buff[0:readbytes]
		}
	}()
	go func() {
		counter := 0
		clientwriter := bufio.NewWriter(con)
		for {
			buff := <-serverToClientChannel
			filename := fmt.Sprintf("%s//%d.rsp", trafficfolder, counter)
			err := ioutil.WriteFile(filename, buff, 0644)
			if err != nil {
				panic(err)
			}
			counter = counter + 1
			clientwriter.Write(buff)
			clientwriter.Flush()

		}
	}()
}

func startRemote(address string, clientToServerChannel chan []byte, serverToClientChannel chan []byte) {
	fmt.Println("starting remote")
	con, error := net.Dial("tcp", address)
	if error != nil {
		panic(error)
	}
	fmt.Printf("connected to %s\n", address)
	reader := bufio.NewReader(con)
	writer := bufio.NewWriter(con)
	go func() {
		for {
			buff := <-clientToServerChannel
			writer.Write(buff)
			writer.Flush()
			fmt.Printf("wrote %d bytes to server\n", len(buff))
		}
	}()
	go func() {
		for {
			buff := make([]byte, 8192)
			readbytes, err := reader.Read(buff)
			fmt.Printf("read %d bytes from server\n", readbytes)
			if err != nil {
				panic(err)
			}
			serverToClientChannel <- buff[0:readbytes]

		}
	}()
}
