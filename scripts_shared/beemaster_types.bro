module beemaster;

@load base/utils/addrs

export {
  type AlertInfo: record {
    timestamp: time;
    incident_type: string;
    protocol: string;
    source_ip: string;
    source_port: count;
    destination_ip: string;
    destination_port: count;
  };
}

function conninfo_to_alertinfo(input: Conn::Info) : AlertInfo {
    local conn = input$id;
    return AlertInfo($timestamp = input$ts, $incident_type = "foo", $protocol = "bar",
        $source_ip = addr_to_uri(conn$orig_h), $source_port = port_to_count(conn$orig_p),
        $destination_ip = addr_to_uri(conn$resp_h), $destination_port = port_to_count(conn$resp_p));
}
