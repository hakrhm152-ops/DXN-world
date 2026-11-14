const express = require('express');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
app.use(express.json());

// إعداد الاتصال بقاعدة البيانات عبر متغيرات البيئة
const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
});

// مسار تجريبي للتحقق من أن الخادم يعمل
app.get('/', (req, res) => {
    res.json({ message: 'مرحباً بك في خادم تطبيق مشرفي ورواد DXN' });
});

// مسار لجلب المنتجات
app.get('/api/products', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM products ORDER BY id DESC');
        res.json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'خطأ في خادم قاعدة البيانات' });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`الخادم يعمل بنجاح على المنفذ ${PORT}`);
});
