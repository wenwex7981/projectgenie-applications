const { Client } = require('pg');

async function testConnection(name, connectionString) {
    const client = new Client({ connectionString, connectionTimeoutMillis: 5000 });
    try {
        console.log(`Testing [${name}]...`);
        await client.connect();
        console.log(`✅ SUCCESS: [${name}]`);
        await client.query('SELECT 1');
        await client.end();
        return true;
    } catch (e) {
        console.log(`❌ FAILED: [${name}] - ${e.message}`);
        return false;
    }
}

async function runTests() {
    const password = "projectgenie@123";
    const encodedPassword = encodeURIComponent(password);

    const urls = [
        { name: "Direct (IPv4 + IPv6 Host)", url: `postgresql://postgres:${encodedPassword}@db.pweuldjxqksffmaednjc.supabase.co:5432/postgres` },
        { name: "Pooler AWS Port 6543", url: `postgresql://postgres.pweuldjxqksffmaednjc:${encodedPassword}@aws-1-ap-southeast-2.pooler.supabase.com:6543/postgres?pgbouncer=true` },
        { name: "Pooler AWS Port 5432", url: `postgresql://postgres.pweuldjxqksffmaednjc:${encodedPassword}@aws-1-ap-southeast-2.pooler.supabase.com:5432/postgres` }
    ];

    for (const opt of urls) {
        await testConnection(opt.name, opt.url);
    }
}

runTests();
