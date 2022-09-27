module WMesa

using PyCall
using DAQCore

export WMesaClient
export move, devposition, setreference, rmove, numaxes, axesnames
export waituntildone, stopmotion, absposition, setabsreference, moveto!
export stopoutputdev

struct WMesaClient <: AbstractOutputDev
    devname::String
    ip::String
    port::Int32
    axis::String
    server::PyObject
end

DAQCore.numaxes(dev::WMesaClient) = 1
DAQCore.numaxes(::Type{WMesaClient}) = 1
DAQCore.axesnames(dev::WMesaClient) = [dev.axis]

function WMesaClient(devname, ip="192.168.0.140", port=9596; axis="θ")
    xmlrpc = pyimport("xmlrpc.client")
    server = xmlrpc.ServerProxy("http://$ip:$port")
    WMesaClient(devname, ip, port, axis, server)
end

move(dev::WMesaClient, deg; a=false, r=false, sync=true) =
    dev.server["move"](deg, a, r, sync)

DAQCore.moveto!(dev::WMesaClient, deg) =
    move(dev, deg[1]; a=false, r=false, sync=true)

rmove(dev::WMesaClient, deg; sync=true) =
    dev.server["move"](deg, false, true, sync)


DAQCore.devposition(dev::WMesaClient) = dev.server["position"]()
absposition(dev::WMesaClient) = dev.server["abs_position"]()

setreference(dev::WMesaClient, deg=0) = dev.server["set_reference"](deg)

setabsreference(dev::WMesaClient) = dev.server["set_abs_reference"]()

DAQCore.waituntildone(dev::WMesaClient) = dev.server["waitUntilDone"]()

stopmotion(dev::WMesaClient) = dev.server["stop"]()
DAQCore.stopoutputdev(dev::WMesaClient) = dev.server["stop"]()

                      


end


