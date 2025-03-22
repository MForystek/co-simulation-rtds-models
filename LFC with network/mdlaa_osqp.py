import numpy as np
import osqp

from scipy.sparse import csc_matrix

import Pyro5.api
from Pyro5.api import register_class_to_dict, register_dict_to_class


def numpy_to_dict(obj: np.ndarray) -> dict:
    # Convert the numpy array to a dict
    return {
        "__class__": "numpy.ndarray",
        "dtype": str(obj.dtype),
        "shape": obj.shape,
        "data": obj.tolist()
    }

def dict_to_numpy(classname: str, d: dict) -> np.ndarray:
    if classname == "numpy.ndarray":
        return np.array(d["data"], dtype=d["dtype"]).reshape(d["shape"])
    return d

# Register the converters for numpy.ndarray
register_class_to_dict(np.ndarray, numpy_to_dict)
register_dict_to_class("numpy.ndarray", dict_to_numpy)


class OSQPSolver:
    
    @Pyro5.api.expose
    def do_osqp(self, H, f, A, lb, ub):
        prob = osqp.OSQP()    
        prob.setup(
            P=csc_matrix(H),
            q=f.flatten(),
            A=csc_matrix(A),
            l=lb,
            u=ub,
            #eps_abs=1e-6,
            #eps_rel=1e-6,
            verbose=True
        )
        print("Solving OSQP...")
        OSQP_result = prob.solve()
        return OSQP_result.info.status, OSQP_result.x
    

if __name__ == "__main__":
    daemon = Pyro5.api.Daemon(host="192.168.152.1", port=9090)
    uri = daemon.register(OSQPSolver, objectId="osqpsolver")
    print("Ready. Object URI:", uri)
    # Keep the server running to listen for incoming requests.
    daemon.requestLoop()
