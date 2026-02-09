const net = require('net');

class TCPProxy {
    constructor(localPort, remoteHost, remotePort) {
        this.localPort = localPort;
        this.remoteHost = remoteHost;
        this.remotePort = remotePort;
        
        this.server = net.createServer((localSocket) => {
            console.log(`[${new Date().toISOString()}] New connection from ${localSocket.remoteAddress}:${localSocket.remotePort}`);
            
            // Создаем соединение с целевым сервером
            const remoteSocket = net.createConnection({
                host: this.remoteHost,
                port: this.remotePort
            }, () => {
                console.log(`[${new Date().toISOString()}] Connected to ${this.remoteHost}:${this.remotePort}`);
            });
            
            // Перенаправляем данные от клиента к целевому серверу
            localSocket.pipe(remoteSocket);
            
            // Перенаправляем данные от целевого сервера к клиенту
            remoteSocket.pipe(localSocket);
            
            // Обработка ошибок
            localSocket.on('error', (err) => {
                console.error(`[${new Date().toISOString()}] Local socket error:`, err.message);
                remoteSocket.end();
            });
            
            remoteSocket.on('error', (err) => {
                console.error(`[${new Date().toISOString()}] Remote socket error:`, err.message);
                localSocket.end();
            });
            
            // Закрытие соединений
            localSocket.on('close', () => {
                console.log(`[${new Date().toISOString()}] Connection closed`);
                remoteSocket.end();
            });
            
            remoteSocket.on('close', () => {
                localSocket.end();
            });
        });
        
        this.server.on('error', (err) => {
            console.error(`[${new Date().toISOString()}] Server error:`, err.message);
        });
        
        this.server.on('listening', () => {
            console.log(`[${new Date().toISOString()}] TCP Proxy started`);
            console.log(`[${new Date().toISOString()}] Listening on port ${this.localPort}`);
            console.log(`[${new Date().toISOString()}] Forwarding to ${this.remoteHost}:${this.remotePort}`);
        });
    }
    
    start() {
        this.server.listen(this.localPort, '0.0.0.0');
    }
    
    stop() {
        this.server.close();
    }
}

// Использование
if (require.main === module) {
    const args = process.argv.slice(2);
    if (args.length !== 3) {
        console.log('Usage: node simple-tcp-proxy.js <local_port> <remote_host> <remote_port>');
        console.log('Example: node simple-tcp-proxy.js 8080 192.168.1.100 3000');
        process.exit(1);
    }
    
    const [localPort, remoteHost, remotePort] = args;
    const proxy = new TCPProxy(parseInt(localPort), remoteHost, parseInt(remotePort));
    proxy.start();
    
    // Обработка сигналов для graceful shutdown
    process.on('SIGINT', () => {
        console.log('\nShutting down proxy...');
        proxy.stop();
        process.exit(0);
    });
}

module.exports = TCPProxy;
