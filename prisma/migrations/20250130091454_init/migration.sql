-- CreateEnum
CREATE TYPE "Region" AS ENUM ('AU', 'UK', 'NZ', 'MY');

-- CreateTable
CREATE TABLE "users" (
    "userid" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expiry" TIMESTAMP(3) NOT NULL,
    "revoked" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "users_pkey" PRIMARY KEY ("userid")
);

-- CreateTable
CREATE TABLE "mainSku" (
    "id" SERIAL NOT NULL,
    "sku" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "region" "Region"[],
    "compute" INTEGER NOT NULL,
    "refs" TEXT,

    CONSTRAINT "mainSku_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "childSku" (
    "id" SERIAL NOT NULL,
    "sku" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "region" "Region"[],
    "compute" INTEGER NOT NULL,
    "parentId" TEXT NOT NULL,

    CONSTRAINT "childSku_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vendor" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,

    CONSTRAINT "vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vendorSku" (
    "id" SERIAL NOT NULL,
    "vendorId" INTEGER NOT NULL,
    "skuId" INTEGER,
    "childSkuId" INTEGER,
    "region" "Region"[],
    "cost" DOUBLE PRECISION NOT NULL,

    CONSTRAINT "vendorSku_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quote" (
    "id" TEXT NOT NULL,
    "created" TIMESTAMP(3) NOT NULL,
    "updated" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "quote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quoteItems" (
    "id" SERIAL NOT NULL,

    CONSTRAINT "quoteItems_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_token_key" ON "users"("token");

-- CreateIndex
CREATE UNIQUE INDEX "mainSku_sku_key" ON "mainSku"("sku");

-- CreateIndex
CREATE UNIQUE INDEX "childSku_sku_key" ON "childSku"("sku");

-- CreateIndex
CREATE UNIQUE INDEX "vendorSku_vendorId_skuId_region_key" ON "vendorSku"("vendorId", "skuId", "region");

-- CreateIndex
CREATE UNIQUE INDEX "vendorSku_vendorId_childSkuId_region_key" ON "vendorSku"("vendorId", "childSkuId", "region");

-- AddForeignKey
ALTER TABLE "childSku" ADD CONSTRAINT "childSku_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "mainSku"("sku") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vendorSku" ADD CONSTRAINT "vendorSku_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "vendor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vendorSku" ADD CONSTRAINT "vendorSku_skuId_fkey" FOREIGN KEY ("skuId") REFERENCES "mainSku"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vendorSku" ADD CONSTRAINT "vendorSku_childSkuId_fkey" FOREIGN KEY ("childSkuId") REFERENCES "childSku"("id") ON DELETE SET NULL ON UPDATE CASCADE;
