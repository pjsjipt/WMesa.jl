module WMesa

using PyCall
using AbstractActuator

export WMesaClient
export move, position, setreference, rmove, numaxes
export waituntildone, stopmotion, absposition, setabsreference

struct WMesaClient <: AbstractRobot
    ip::String
    port::Int32
    server::PyObject
end

AbstractActuator.numaxes(dev::WMesaClient) = 1
AbstractActuator.numaxes(::Type{WMesaClient}) = 1

function WMesaClient(ip="192.168.0.140", port=9596)
    xmlrpc = pyimport("xmlrpc.client")
    server = xmlrpc.ServerProxy("http://$ip:$port")
    WMesaClient(ip, port, server)
end

AbstractActuator.move(dev::WMesaClient, deg; a=false, r=false, sync=true) =
    dev.server["move"](deg, a, r, sync)

AbstractActuator.rmove(dev::WMesaClient, deg; sync=true) =
    dev.server["move"](deg, false, true, sync)


AbstractActuator.position(dev::WMesaClient) = dev.server["position"]()
AbstractActuator.absposition(dev::WMesaClient) = dev.server["abs_position"]()

AbstractActuator.setreference(dev::WMesaClient, deg=0) = dev.server["set_reference"](deg)

AbstractActuator.setabsreference(dev::WMesaClient) = dev.server["set_abs_reference"]()

AbstractActuator.waituntildone(dev::WMesaClient) = dev.server["waitUntilDone"]()

AbstractActuator.stopmotion(dev::WMesaClient) = dev.server["stop"]()


end
