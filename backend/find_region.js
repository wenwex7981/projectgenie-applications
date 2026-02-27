const { Client } = require('pg');

const regions = [
    'ap-south-1', // Mumbai
    'ap-southeast-1', // Singapore
    'ap-southeast-2', // Sydney
    'ap-northeast-1', // Tokyo
    'us-east-1', // N. Virginia
    'us-east-2', // Ohio
    'us-west-1', // N. California
    'us-west-2', // Oregon
    'eu-west-1', // Ireland
    'eu-west-2', // London
    'eu-central-1', // Frankfurt
];

async function checkRegion(region) {
    // Use port 6543 with pgbouncer=true to test the pooler routing
    const connectionString = `postgresql://postgres.pweuldjxqksffmaednjc:projectgenie%40123@aws-0-${region}.pooler.supabase.com:6543/postgres`;
    const client = new Client({ connectionString, connectionTimeoutMillis: 5000 });

    try {
        await client.connect();
        console.log(`✅ Success in region: ${region}`);
        await client.end();
        return region;
    } catch (e) {
        if (e.message.includes('Tenant or user not found')) {
            // This means we connected to the proxy, but this region doesn't host this project
        } else if (e.message.includes('password authentication failed')) {
            console.log(`❌ Password failed in region: ${region}`);
            return 'wrong_password';
        } else {
            console.log(`⚠️ Other error in ${region}: ${e.message}`);
        }
        return null;
    }
}

async function run() {
    console.log("Searching for the correct Supabase region...");
    for (const region of regions) {
        const result = await checkRegion(region);
        if (result) {
            console.log(`\n🎉 FOUND IT! The correct region is: ${result}`);
            return;
        }
    }
    console.log(`\n❌ Could not find the region. The password might be wrong, or the database is paused.`);
}

run();
