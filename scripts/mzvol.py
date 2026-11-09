import sys, json
d = json.load(sys.stdin)
for v in d.get("entries", []):
    sp = v.get("spec", {})
    st = v.get("state", {})
    print("volume", sp.get("uuid"), "| replicas wanted:", sp.get("num_replicas"), "| status:", st.get("status"))
    for rid, r in (st.get("replica_topology") or {}).items():
        print("   replica", rid[:8], "| node:", r.get("node"), "| pool:", r.get("pool"), "| state:", r.get("state"))
    t = st.get("target") or {}
    print("   target node:", t.get("node"))
