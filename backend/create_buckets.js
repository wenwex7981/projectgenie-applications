require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env");
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

async function setupBuckets() {
    const bucketsToCreate = [
        { name: 'vendor_assets', public: true, fileSizeLimit: 52428800, allowedMimeTypes: ['image/*', 'video/*'] },
        { name: 'buyer_assets', public: true, fileSizeLimit: 10485760, allowedMimeTypes: ['image/*'] },
        { name: 'documents', public: false, fileSizeLimit: 52428800, allowedMimeTypes: ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 'application/zip'] }
    ];

    console.log("Setting up Supabase Storage Buckets...");

    // Get existing buckets
    const { data: existingBuckets, error: listError } = await supabase.storage.listBuckets();
    if (listError) {
        console.error("Error listing buckets:", listError);
        return;
    }

    const existingNames = existingBuckets.map(b => b.name);

    // Create new buckets
    for (const bucket of bucketsToCreate) {
        if (existingNames.includes(bucket.name)) {
            console.log(`✅ Bucket '${bucket.name}' already exists.`);
            // Update config just in case
            const { error: updateError } = await supabase.storage.updateBucket(bucket.name, {
                public: bucket.public,
                fileSizeLimit: bucket.fileSizeLimit,
                allowedMimeTypes: bucket.allowedMimeTypes,
            });
            if (updateError) console.error(`⚠️ Failed to update '${bucket.name}':`, updateError.message);
            else console.log(`   Updated config for '${bucket.name}'`);
        } else {
            console.log(`Creating bucket '${bucket.name}'...`);
            const { error: createError } = await supabase.storage.createBucket(bucket.name, {
                public: bucket.public,
                fileSizeLimit: bucket.fileSizeLimit,
                allowedMimeTypes: bucket.allowedMimeTypes,
            });
            if (createError) {
                console.error(`❌ Failed to create '${bucket.name}':`, createError.message);
            } else {
                console.log(`✅ Successfully created '${bucket.name}'.`);
            }
        }
    }

    console.log("\nNext Steps: Ensure you create Row Level Security (RLS) policies for storage.objects in Supabase dashboard to allow public uploads if needed, or stick to backend uploads!");
}

setupBuckets();
