import os
from dotenv import load_dotenv
from supabase import create_client, Client

load_dotenv()

url = os.environ.get("SUPABASE_URL")
key = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
supabase = create_client(url, key)

def delete_all(table_name):
    print(f"Fetching all rows from {table_name}...")
    try:
        # Assuming there is a primary key column we can query, we'll try to just select '*' and delete by matching row fields.
        # But for safety, let's just select whatever is returned and try to delete using everything.
        # Wait, if we use eq('id', ...) it assumes 'id' exists. 
        # Supabase allows .neq("id", "this-will-never-match") but only if 'id' exists.
        # Let's try to fetch rows.
        res = supabase.table(table_name).select("*").execute()
        rows = res.data
        if not rows:
            print(f"No rows found in {table_name}.")
            return
        
        # Determine the primary key column name. usually 'id'
        pk_col = 'id'
        if len(rows) > 0 and 'id' not in rows[0]:
            print(f"Warning: 'id' not found in {table_name} row keys: {rows[0].keys()}")
            pk_col = list(rows[0].keys())[0] # Just use the first column as a fallback guess
        
        for row in rows:
            supabase.table(table_name).delete().eq(pk_col, row[pk_col]).execute()
        print(f"Deleted {len(rows)} rows from {table_name}.")
    except Exception as e:
        print(f"Error processing {table_name}: {e}")

if __name__ == "__main__":
    delete_all("patients")
    delete_all("profiles")
