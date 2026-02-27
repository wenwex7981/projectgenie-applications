const { Client } = require('pg');

const regions = [
    'ap-south-1',
    'ap-southeast-1',
    'ap-southeast-2',
    'ap-northeast-1',
    'ap-northeast-2',
    'us-east-1',
    'us-east-2',
    'us-west-1',
    'us-west-2',
    'eu-west-1',
    'eu-west-2',
    'eu-central-1',
    'sa-east-1',
    'ca-central-1'
];

async function checkRegion(region) {
    const connectionString = `postgresql://postgres.pweuldjxqksffmaednjc:projectgenie%40123@aws-0-${region}.pooler.supabase.com:5432/postgres`;
    const client = new Client({ connectionString, connectionTimeoutMillis: 3000 });
    try {
        await client.connect();
        console.log(`✅ Success: ${region}`);
        await client.end();
        return region;
    } catch (e) {
        if (!e.message.includes('Tenant or user not found')) {
            console.log(`❌ Failed: ${region} - ${e.message}`);
        }
        return null;
    }
}

async function run() {
    console.log("Searching for the correct region...");
    const promises = regions.map(r => checkRegion(r));
    const results = await Promise.all(promises);
    const success = results.find(r => r !== null);
    if (success) {
        console.log(`\nFOUND COMPATIBLE REGION: ${success}`);
    } else {
        console.log(`\nCould not find region. Either password is wrong or project is paused.`);
    }
}
run();
