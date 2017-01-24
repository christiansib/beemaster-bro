@load ./slave_log.bro

redef exit_only_after_terminate = T;

# the ports and IPs that are externally routable for a master and this slave
const slave_broker_port: string = getenv("SLAVE_PUBLIC_PORT") &redef;
const slave_broker_ip: string = getenv("SLAVE_PUBLIC_IP") &redef;
const master_broker_port: port = to_port(cat(getenv("MASTER_PUBLIC_PORT"), "/tcp")) &redef;
const master_broker_ip: string = getenv("MASTER_PUBLIC_IP") &redef;

# the port that is internally used (inside the container) to listen to
const broker_port: port = 9999/tcp &redef;

redef Broker::endpoint_name = cat("bro-slave-", slave_broker_ip, ":", slave_broker_port);

global dionaea_access: event(timestamp: time, dst_ip: addr, dst_port: count, src_hostname: string, src_ip: addr, src_port: count, transport: string, protocol: string, connector_id: string);
global dionaea_ftp: event(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, command: string, arguments: string, origin: string, connector_id: string);
global dionaea_mysql_command: event(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, args: string, origin: string, connector_id: string);
global dionaea_mysql_login: event(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, username: string, password: string, origin: string, connector_id: string);
global dionaea_download_complete: event(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, url: string, md5hash: string, filelocation: string, origin: string, connector_id: string);
global dionaea_download_offer: event(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, url: string, origin: string, connector_id: string);
global dionaea_smb_request: event(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, opnum: count, uuid: string, origin: string, connector_id: string);
global dionaea_smb_bind: event(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, transfersyntax: string, uuid: string, origin: string, connector_id: string);
global dionaea_blackhole: event(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, input: string, length: count, origin: string, connector_id: string);
global log_bro: function(msg: string);
global log_conn: event(rec: Conn::Info);
global published_events: set[string] = { "dionaea_access", "dionaea_ftp", "dionaea_mysql_command", "dionaea_mysql_login", "dionaea_download_complete", "dionaea_download_offer", "dionaea_smb_request", "dionaea_smb_bind", "dionaea_blackhole", "log_conn"};


event bro_init() {
    log_bro("bro_slave.bro: bro_init()");
    Broker::enable([$auto_publish=T, $auto_routing=T]);
    
    # Listening
    Broker::listen(broker_port, "0.0.0.0");
    Broker::subscribe_to_events("honeypot/dionaea");
    Broker::subscribe_to_events_multi("honeypot/dionaea");
    
    # Forwarding
    Broker::connect(master_broker_ip, master_broker_port, 1sec);
    Broker::register_broker_events("honeypot/dionaea", published_events);

    # Try unsolicited option, which should prevent topic issues
    Broker::auto_event("honeypot/dionaea", dionaea_access);
    log_bro("bro_slave.bro: bro_init() done");
}

event bro_done() {
  log_bro("bro_slave.bro: bro_done()");
}

event dionaea_access(timestamp: time, dst_ip: addr, dst_port: count, src_hostname: string, src_ip: addr, src_port: count, transport: string, protocol: string, connector_id: string) {
    event dionaea_access(timestamp, dst_ip, dst_port, src_hostname, src_ip, src_port, transport, protocol, connector_id);
}
event dionaea_ftp(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, command: string, arguments: string, origin: string, connector_id: string) {

    event dionaea_ftp(timestamp, id, local_ip, local_port, remote_ip, remote_port, transport, protocol, command, arguments, origin, connector_id);
}
event dionaea_mysql_command(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, args: string, origin: string, connector_id: string) {

    event dionaea_mysql_command(timestamp, id, local_ip, local_port, remote_ip, remote_port, transport, protocol, args, origin, connector_id);
}
event dionaea_mysql_login(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, username: string, password: string, origin: string, connector_id: string) {

    event dionaea_mysql_login(timestamp, id, local_ip, local_port, remote_ip, remote_port, transport, protocol, username, password, origin, connector_id);
}
event dionaea_download_complete(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, url: string, md5hash: string, filelocation: string, origin: string, connector_id: string) {

    event dionaea_download_complete(timestamp, id, local_ip, local_port, remote_ip, remote_port, transport, protocol, url, md5hash, filelocation, origin, connector_id);
}
event dionaea_download_offer(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, url: string, origin: string, connector_id: string) {
    event dionaea_download_offer(timestamp, id, local_ip, local_port, remote_ip, remote_port, transport, protocol, url, origin, connector_id);
}
event dionaea_smb_request(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, opnum: count, uuid: string, origin: string, connector_id: string) {

    event dionaea_smb_request(timestamp, id, local_ip, local_port, remote_ip, remote_port, transport, protocol, opnum, uuid, origin, connector_id);
}
event dionaea_smb_bind(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, transfersyntax: string, uuid: string, origin: string, connector_id: string) {

    event dionaea_smb_bind(timestamp, id, local_ip, local_port, remote_ip, remote_port, transport, protocol, transfersyntax, uuid, origin, connector_id);
}
event dionaea_blackhole(timestamp: time, id: string, local_ip: addr, local_port: count, remote_ip: addr, remote_port: count, transport: string, protocol: string, input: string, length: count, origin: string, connector_id: string) {

    event dionaea_blackhole(timestamp, id, local_ip, local_port, remote_ip, remote_port, transport, protocol, input, length, origin, connector_id);
}

event Broker::incoming_connection_established(peer_name: string) {
    local msg: string = "Incoming_connection_established " + peer_name;
    log_bro(msg);
}
event Broker::incoming_connection_broken(peer_name: string) {
    local msg: string = "Incoming_connection_broken " + peer_name;
    log_bro(msg);
}
event Broker::outgoing_connection_established(peer_address: string, peer_port: port, peer_name: string) {
    local msg: string = "Outgoing connection established to: " + peer_address; 
    log_bro(msg);
}
event Broker::outgoing_connection_broken(peer_address: string, peer_port: port, peer_name: string) {
    local msg: string = "Outgoing connection broken with: " + peer_address;
    log_bro(msg);
}

# forwarding when some local connection is beeing logged. Throws an explicit beemaster event to forward.
event Conn::log_conn(rec: Conn::Info) {
    event log_conn(rec);
}

function log_bro(msg: string) {
    local rec: Brolog::Info = [$msg=msg];
    Log::write(Brolog::LOG, rec);
}
