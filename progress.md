# Progress - 2026-04-22

## Tamamlananlar

- `backend/` iskeleti olusturuldu.
- `/health` endpoint'i calisiyor.
- `mobile/` Flutter iskeleti olusturuldu.
- Flutter uygulamasi Chrome'da basariyla calisiyor.
- Cursor kurallari guncellendi:
  - FastAPI rule eklendi.
  - Flutter rule eklendi.
  - Design system rule eklendi.
- FastAPI dokumantasyonu eklendi.
- Flutter dokumantasyonu eklendi.
- `plan.md` olusturuldu.

# Progress - 2026-05-13

## Tamamlananlar
- Supabase paketi kuruldu
- backend/routers/ yapısı oluşturuldu
- GET /daily-question/, GET/POST /entries/, GET /entries/{id} endpoint'leri yazıldı
- CORS middleware eklendi
- Swagger UI çalıştırıldı, endpoint'ler test edildi
- ER diyagramı Mermaid formatında oluşturuldu
- Flutter home ekranı backend /daily-question/ endpoint'ine bağlandı

# Progress - 2026-06-03

## Tamamlananlar
- POST /enrich/ endpoint'i eklendi
- Claude Haiku (claude-haiku-4-5) AI entegrasyonu tamamlandı
- Flutter enrich_screen.dart gerçek AI endpoint'ine bağlandı
- enrichedTextProvider mock'tan FutureProvider'a dönüştürüldü
- api_service.dart enrichEntry metodu eklendi
- .gitignore düzeltildi, .vscode tracking'den kaldırıldı
- Tüm Flutter ekranları GitHub'a push edildi
