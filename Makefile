current_dir := $(abspath $(patsubst %/,%,$(dir $(MAKEFILE_LIST))))

postgres:
	docker run --name postgresdb -p 50:5432 -e POSTGRES_PASSWORD=1234 -e POSTGRES_USER=root -d postgres:12-alpine

createdb:
	docker exec -it postgresdb createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgresdb dropdb simple_bank

migrateup:
	migrate -path ./migration -database "postgresql://root:1234@localhost:50/simple_bank?sslmode=disable" -verbose up 

migratedown:
	migrate -path ./migration -database "postgresql://root:1234@localhost:50/simple_bank?sslmode=disable" -verbose down

sqlc:
	docker run --rm -v "$(current_dir):/src" -w /src kjconroy/sqlc generate

test:
	go test -v -cover ./...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test