-- جدول المستخدمين الأساسي
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(50),
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('super_admin', 'supervisor', 'member', 'visitor')) DEFAULT 'visitor',
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ملف العضو المرتبط برقم DXN
CREATE TABLE member_profiles (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    dxn_member_id VARCHAR(50) UNIQUE NOT NULL,
    supervisor_id INT REFERENCES users(id),
    join_date DATE,
    verification_status VARCHAR(20) DEFAULT 'pending'
);

-- لقطات النقاط (Snapshots) لعدم تعديل بيانات المصدر الأصلي
CREATE TABLE points_snapshots (
    id SERIAL PRIMARY KEY,
    member_profile_id INT REFERENCES member_profiles(id) ON DELETE CASCADE,
    points_value NUMERIC(10, 2) NOT NULL,
    points_type VARCHAR(50),
    source_url TEXT,
    fetched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sync_status VARCHAR(20),
    notes TEXT
);

-- المنتجات
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    category_id INT,
    price NUMERIC(10, 2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    availability BOOLEAN DEFAULT TRUE,
    image_url TEXT,
    created_by INT REFERENCES users(id)
);

-- سجل التدقيق والمراجعة للأمان
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    actor_id INT REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50),
    entity_id INT,
    old_value TEXT,
    new_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
