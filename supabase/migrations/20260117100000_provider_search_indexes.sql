-- Add indexes to optimize provider search queries with pagination

-- Provider type filtering
CREATE INDEX IF NOT EXISTS idx_provider_profiles_provider_type
ON provider_profiles(provider_type);

-- Status filtering
CREATE INDEX IF NOT EXISTS idx_provider_profiles_status
ON provider_profiles(status);

-- Company name search (case-insensitive)
CREATE INDEX IF NOT EXISTS idx_companies_name_lower
ON companies(lower(name));

-- Composite index for type + status filtering
CREATE INDEX IF NOT EXISTS idx_provider_profiles_type_status
ON provider_profiles(provider_type, status);

-- Company type filtering (for provider/buyer_provider filter)
CREATE INDEX IF NOT EXISTS idx_companies_type
ON companies(type);
