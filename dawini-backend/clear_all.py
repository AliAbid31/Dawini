import os
import json
import urllib.request
from urllib.error import HTTPError

url = "https://jjaipaqwwqhklvivyaog.supabase.co"
key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpqYWlwYXF3d3Foa2x2aXZ5YW9nIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4MTg1NDAzOSwiZXhwIjoyMDk3NDMwMDM5fQ.OsN01r2PiMUnKsyknfaL01ghCk10I2pf990wbZ35Cxo"

headers = {
    "apikey": key,
    "Authorization": f"Bearer {key}",
    "Content-Type": "application/json"
}

def request(method, path):
    req = urllib.request.Request(f"{url}/rest/v1{path}", headers=headers, method=method)
    try:
        with urllib.request.urlopen(req) as response:
            if response.status == 204:
                return None
            data = response.read()
            if data:
                return json.loads(data)
            return None
    except HTTPError as e:
        body = e.read().decode('utf-8')
        if method == "DELETE" and e.code == 409:
            print(f"409 Error on {path}: {body}")
            raise e
        return None

openapi = request("GET", "/")
tables = [k[1:] for k in openapi.get("paths", {}).keys() if k.startswith("/") and len(k) > 1 and "{" not in k and "?" not in k]
tables = [t for t in tables if t != "rpc"]

print(f"Found tables: {tables}")

for table in tables:
    rows = request("GET", f"/{table}?select=*")
    if rows:
        print(f"Table {table} has {len(rows)} rows.")
        for row in rows:
            if 'id' in row:
                pk_col = 'id'
            else:
                pk_col = list(row.keys())[0] if len(row.keys()) > 0 else None
            
            if pk_col:
                try:
                    request("DELETE", f"/{table}?{pk_col}=eq.{row[pk_col]}")
                except HTTPError as e:
                    pass

print("Finished.")
