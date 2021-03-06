module WMesa

using PyCall
using AbstractActuators

export WMesaClient
export move, devposition, setreference, rmove, numaxes, axesnames
export waituntildone, stopmotion, absposition, setabsreference, moveto

struct WMesaClient <: AbstractRobot
    devname::String
    ip::String
    port::Int32
    axis::String
    server::PyObject
end

AbstractActuators.numaxes(dev::WMesaClient) = 1
AbstractActuators.numaxes(::Type{WMesaClient}) = 1
AbstractActuators.axesnames(dev::WMesaClient) = [dev.axis]

function WMesaClient(devname, ip="192.168.0.140", port=9596; axis="θ")
    xmlrpc = pyimport("xmlrpc.client")
    server = xmlrpc.ServerProxy("http://$ip:$port")
    WMesaClient(devname, ip, port, axis, server)
end

AbstractActuators.move(dev::WMesaClient, deg; a=false, r=false, sync=true) =
    dev.server["move"](deg, a, r, sync)

AbstractActuators.moveto(dev::WMesaClient, deg) =
    move(dev, deg[1]; a=false, r=false, sync=true)

AbstractActuators.rmove(dev::WMesaClient, deg; sync=true) =
    dev.server["move"](deg, false, true, sync)


AbstractActuators.devposition(dev::WMesaClient) = dev.server["position"]()
AbstractActuators.absposition(dev::WMesaClient) = dev.server["abs_position"]()

AbstractActuators.setreference(dev::WMesaClient, deg=0) = dev.server["set_reference"](deg)

AbstractActuators.setabsreference(dev::WMesaClient) = dev.server["set_abs_reference"]()

AbstractActuators.waituntildone(dev::WMesaClient) = dev.server["waitUntilDone"]()

AbstractActuators.stopmotion(dev::WMesaClient) = dev.server["stop"]()



end


