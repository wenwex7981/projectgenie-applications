-- Run this to allow ANY uploads to your new storage buckets

-- Allow generic public uploads to vendor_assets
CREATE POLICY "Allow public uploads to vendor_assets" 
ON storage.objects FOR INSERT 
TO public 
WITH CHECK (bucket_id = 'vendor_assets');

-- Allow generic public uploads to buyer_assets
CREATE POLICY "Allow public uploads to buyer_assets" 
ON storage.objects FOR INSERT 
TO public 
WITH CHECK (bucket_id = 'buyer_assets');

-- Allow generic public uploads to documents
CREATE POLICY "Allow public uploads to documents" 
ON storage.objects FOR INSERT 
TO public 
WITH CHECK (bucket_id = 'documents');

-- Allow public updates to existing assets
CREATE POLICY "Allow public updates to vendor_assets" 
ON storage.objects FOR UPDATE 
TO public 
USING (bucket_id = 'vendor_assets');

CREATE POLICY "Allow public updates to buyer_assets" 
ON storage.objects FOR UPDATE 
TO public 
USING (bucket_id = 'buyer_assets');

CREATE POLICY "Allow public updates to documents" 
ON storage.objects FOR UPDATE 
TO public 
USING (bucket_id = 'documents');

-- Allow public deletes
CREATE POLICY "Allow public delete to vendor_assets" 
ON storage.objects FOR DELETE 
TO public 
USING (bucket_id = 'vendor_assets');

CREATE POLICY "Allow public delete to buyer_assets" 
ON storage.objects FOR DELETE 
TO public 
USING (bucket_id = 'buyer_assets');

CREATE POLICY "Allow public delete to documents" 
ON storage.objects FOR DELETE 
TO public 
USING (bucket_id = 'documents');
