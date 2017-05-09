/**
 * @author Vadim Usoltsev
 * @version $Id$
 *          $LastChangedDate$
 *          $Author$
 *          $Date$
 *          $Rev$
 */
package ru.koldoon.model {
    import com.greensock.TweenMax;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.events.ServerSocketConnectEvent;
    import flash.net.ServerSocket;
    import flash.net.Socket;

    [Event(name="messageRecieved", type="ru.koldoon.model.LogEvent")]
    [Event(name="clientConnected", type="flash.events.Event")]

    public class LoggerSocketServer extends EventDispatcher {
        public static const CLIENT_PORT:uint = 64661;
        public static const STREAM_DELIMITER:String = "!SOS!";

        [Embed(source="/ru/koldoon/resources/crossdomain.xml", mimeType="application/octet-stream")]
        public static const CrossdomainXml:Class;

        [Bindable]
        public var activeConnection:Boolean;


        public function LoggerSocketServer() {
            initLogServer();
            initPolicyServer();
        }


        private var socketBuffer:String = "";
        private var logSocketServer:ServerSocket = new ServerSocket();
        private var clientSocket:Socket;
        private var policyDataSent:Boolean = false;


        private function initLogServer():void {
            logSocketServer.bind(CLIENT_PORT, "127.0.0.1");
            logSocketServer.addEventListener(ServerSocketConnectEvent.CONNECT, logServer_connectHandler);
            logSocketServer.listen();
        }


        private function logServer_connectHandler(event:ServerSocketConnectEvent):void {
            if (clientSocket) {
                clientSocket.removeEventListener(ProgressEvent.SOCKET_DATA, clientSocket_socketDataHandler);
                clientSocket.removeEventListener(Event.CLOSE, clientSocket_closeHandler);
            }

            policyDataSent = false;
            socketBuffer = "";
            clientSocket = event.socket;
            clientSocket.addEventListener(ProgressEvent.SOCKET_DATA, clientSocket_socketDataHandler);
            clientSocket.addEventListener(Event.CLOSE, clientSocket_closeHandler);
            socketBuffer = "";
            activeConnection = true;
            dispatchEvent(new Event("clientConnected"));

            dispatchLogEvent(
                {
                    time:    new Date().getTime(),
                    message: "LOGGER: Client connected",
                    key:     "WARN"
                });
        }


        private function clientSocket_closeHandler(event:Event):void {
            activeConnection = false;
            clientSocket.removeEventListener(ProgressEvent.SOCKET_DATA, clientSocket_socketDataHandler);
            clientSocket.removeEventListener(Event.CLOSE, clientSocket_closeHandler);

            dispatchLogEvent(
                {
                    time:    (new Date()).getTime(),
                    message: "LOGGER: Client disconnected",
                    key:     "WARN"
                });
        }


        private function clientSocket_socketDataHandler(event:ProgressEvent):void {
            socketBuffer += clientSocket.readUTFBytes(clientSocket.bytesAvailable);

            // Check policy request (once only)
            if (!policyDataSent && socketBuffer.indexOf("<policy-file-request/>") > -1) {
                sendPolicyData(clientSocket);
                policyDataSent = true;
                return;
            }

            var jsonMessages:Array = socketBuffer.split(STREAM_DELIMITER);

            while (jsonMessages.length > 0) {
                var jsonMsg:String = jsonMessages.shift();
                if (!jsonMsg || jsonMsg == "") {
                    continue;
                }

                var logObj:Object = null;

                try {
                    logObj = JSON.parse(jsonMsg);
                }
                catch (err:Error) {
                    socketBuffer = jsonMsg;
                    return;
                }

                if (logObj) {
                    dispatchLogEvent(logObj);
                }
            }

            socketBuffer = "";
        }


        private function dispatchLogEvent(data:Object):void {
            var logEvent:LogEvent = new LogEvent(LogEvent.MSG);
            logEvent.logItem.category = data.category;
            logEvent.logItem.key = data.key;
            logEvent.logItem.message = data.message;
            logEvent.logItem.time = data.time;

            dispatchEvent(logEvent);
        }


        // -----------------------------------------------------------------------------------
        // Flash Policy
        // -----------------------------------------------------------------------------------

        private var policySocketServer:ServerSocket = new ServerSocket();
        private var policyClientSocket:Socket;


        private function initPolicyServer():void {
            try {
                policySocketServer.bind(843, "127.0.0.1");
                policySocketServer.addEventListener(ServerSocketConnectEvent.CONNECT, policyServer_connectHandler);
                policySocketServer.listen();
            }
            catch (err:Error) {
                // retry
                TweenMax.to(this, 0, {
                    delay:      2,
                    onComplete: function ():void {
                        initPolicyServer();
                    }
                })
            }
        }


        private function policyServer_connectHandler(event:ServerSocketConnectEvent):void {
            policyClientSocket = event.socket;
            policyClientSocket.addEventListener(ProgressEvent.SOCKET_DATA, policyClient_socketDataHandler);
        }


        public function policyClient_socketDataHandler(event:ProgressEvent):void {
            policyClientSocket.removeEventListener(ProgressEvent.SOCKET_DATA, policyClient_socketDataHandler);

            var socketData:String = policyClientSocket.readUTFBytes(policyClientSocket.bytesAvailable);
            if (socketData.indexOf("<policy-file-request/>") > -1) {
                sendPolicyData(policyClientSocket);
                policyClientSocket.close();
            }
        }


        private static function sendPolicyData(socket:Socket):void {
            var policyXml:String = new CrossdomainXml();
            socket.writeUTFBytes(policyXml);
            socket.flush();
        }
    }
}
