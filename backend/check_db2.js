const { Client } = require('pg');

async function checkDirect() {
    const connectionString = `postgresql://postgres:projectgenie%40123@db.pweuldjxqksffmaednjc.supabase.co:5432/postgres`;
    const client = new Client({ connectionString, connectionTimeoutMillis: 5000 });
    try {
        await client.connect();
        console.log(`✅ Success direct connection without project reference`);
        await client.end();
        return true;
    } catch (e) {
        console.log(`❌ Failed: ${e.message}`);
    }

    const connectionString2 = `postgresql://postgres.pweuldjxqksffmaednjc:projectgenie%40123@db.pweuldjxqksffmaednjc.supabase.co:5432/postgres`;
    const client2 = new Client({ connectionString: connectionString2, connectionTimeoutMillis: 5000 });
    try {
        await client2.connect();
        console.log(`✅ Success direct connection with project reference`);
        await client2.end();
        return true;
    } catch (e) {
        console.log(`❌ Failed: ${e.message}`);
    }
}

checkDirect();
