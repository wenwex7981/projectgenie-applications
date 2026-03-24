const https = require('https');

const BASE_URL = 'https://projectgenie-api.onrender.com';

const endpoints = [
  { method: 'GET', path: '/health', name: 'Health Check' },
  { method: 'GET', path: '/services', name: 'Get Services (Buyer)' },
  { method: 'GET', path: '/services/trending', name: 'Get Trending Services (Buyer)' },
  { method: 'GET', path: '/projects', name: 'Get Projects (Buyer)' },
  { method: 'GET', path: '/hackathons', name: 'Get Hackathons (Buyer)' },
  { method: 'GET', path: '/categories', name: 'Get Categories' }
];

async function runTests() {
  console.log('🚀 Starting API Endpoint Tests against ' + BASE_URL + '\n');
  let passed = 0;
  
  for (const ep of endpoints) {
    await new Promise((resolve) => {
      const start = Date.now();
      const req = https.request(BASE_URL + ep.path, { method: ep.method }, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => {
          const time = Date.now() - start;
          if (res.statusCode === 200 || res.statusCode === 201) {
            console.log(`✅ [${ep.method}] ${ep.path} (${ep.name}) - ${res.statusCode} OK - ${time}ms`);
            passed++;
          } else {
            console.log(`❌ [${ep.method}] ${ep.path} (${ep.name}) - Failed with status ${res.statusCode}`);
            console.log(`   Response: ${data.substring(0, 100)}`);
          }
          resolve();
        });
      });
      
      req.on('error', (err) => {
        console.log(`❌ [${ep.method}] ${ep.path} (${ep.name}) - Request Error: ${err.message}`);
        resolve();
      });
      
      req.end();
    });
  }
  
  console.log(`\n🎉 Test Summary: ${passed}/${endpoints.length} public endpoints passed successfully.`);
}

runTests();
