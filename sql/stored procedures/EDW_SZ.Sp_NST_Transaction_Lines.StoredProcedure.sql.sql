USE [YETISQLDW01]
GO
/****** Object:  StoredProcedure [EDW_SZ].[Sp_NST_Transaction_Lines]    Script Date: 10/18/2018 11:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [EDW_SZ].[Sp_NST_Transaction_Lines] AS

if object_id('EDW_RZ.NST_Transaction_Lines') is not null begin
Drop EXTERNAL TABLE EDW_RZ.NST_Transaction_Lines end;
CREATE EXTERNAL TABLE EDW_RZ.NST_Transaction_Lines
(
ACCOUNT_ID [nvarchar](2000) NULL,
ALT_SALES_AMOUNT [nvarchar](2000) NULL,
AMORTIZATION_RESIDUAL [nvarchar](2000) NULL,
AMOUNT [nvarchar](2000) NULL,
AMOUNT_FOREIGN [nvarchar](2000) NULL,
AMOUNT_FOREIGN_LINKED [nvarchar](2000) NULL,
AMOUNT_LINKED [nvarchar](2000) NULL,
AMOUNT_PENDING [nvarchar](2000) NULL,
AMOUNT_SETTLEMENT [nvarchar](2000) NULL,
AMOUNT_TAXABLE [nvarchar](2000) NULL,
AMOUNT_TAXED [nvarchar](2000) NULL,
BILLING_SCHEDULE_ID [nvarchar](2000) NULL,
BILL_VARIANCE_STATUS [nvarchar](2000) NULL,
BOM_QUANTITY [nvarchar](2000) NULL,
CATCH_UP_PERIOD_ID [nvarchar](2000) NULL,
CHARGE_TYPE [nvarchar](2000) NULL,
CLASS_ID [nvarchar](2000) NULL,
COMPANY_ID [nvarchar](2000) NULL,
COMPONENT_ID [nvarchar](2000) NULL,
COMPONENT_YIELD [nvarchar](2000) NULL,
COST_ESTIMATE_TYPE [nvarchar](2000) NULL,
DATE_CLEARED [nvarchar](2000) NULL,
DATE_CLOSED [nvarchar](2000) NULL,
DATE_CREATED [nvarchar](2000) NULL,
DATE_LAST_MODIFIED [nvarchar](2000) NULL,
DATE_LAST_MODIFIED_GMT [nvarchar](2000) NULL,
DATE_REVENUE_COMMITTED [nvarchar](2000) NULL,
DELAY_REV_REC [nvarchar](2000) NULL,
DEPARTMENT_ID [nvarchar](2000) NULL,
DO_NOT_DISPLAY_LINE [nvarchar](2000) NULL,
DO_NOT_PRINT_LINE [nvarchar](2000) NULL,
DO_RESTOCK [nvarchar](2000) NULL,
ESTIMATED_COST [nvarchar](2000) NULL,
ESTIMATED_COST_FOREIGN [nvarchar](2000) NULL,
EXPECTED_RECEIPT_DATE [nvarchar](2000) NULL,
EXPENSE_CATEGORY_ID [nvarchar](2000) NULL,
GL_NUMBER [nvarchar](2000) NULL,
GL_SEQUENCE [nvarchar](2000) NULL,
GL_SEQUENCE_ID [nvarchar](2000) NULL,
GROSS_AMOUNT [nvarchar](2000) NULL,
HAS_COST_LINE [nvarchar](2000) NULL,
ISBILLABLE [nvarchar](2000) NULL,
ISCLEARED [nvarchar](2000) NULL,
ISNONREIMBURSABLE [nvarchar](2000) NULL,
ISTAXABLE [nvarchar](2000) NULL,
IS_ALLOCATION [nvarchar](2000) NULL,
IS_AMORTIZATION_REV_REC [nvarchar](2000) NULL,
IS_COMMITMENT_CONFIRMED [nvarchar](2000) NULL,
IS_COST_LINE [nvarchar](2000) NULL,
IS_CUSTOM_LINE [nvarchar](2000) NULL,
IS_EXCLUDE_FROM_RATE_REQUEST [nvarchar](2000) NULL,
IS_FX_VARIANCE [nvarchar](2000) NULL,
IS_ITEM_VALUE_ADJUSTMENT [nvarchar](2000) NULL,
IS_LANDED_COST [nvarchar](2000) NULL,
IS_SCRAP [nvarchar](2000) NULL,
IS_VSOE_ALLOCATION_LINE [nvarchar](2000) NULL,
ITEM_COUNT [nvarchar](2000) NULL,
ITEM_ID [nvarchar](2000) NULL,
ITEM_RECEIVED [nvarchar](2000) NULL,
ITEM_SOURCE [nvarchar](2000) NULL,
ITEM_UNIT_PRICE [nvarchar](2000) NULL,
KIT_PART_NUMBER [nvarchar](2000) NULL,
LANDED_COST_SOURCE_LINE_ID [nvarchar](2000) NULL,
LOCATION_ID [nvarchar](2000) NULL,
MATCH_BILL_TO_RECEIPT [nvarchar](2000) NULL,
NEEDS_REVENUE_ELEMENT [nvarchar](2000) NULL,
NET_AMOUNT [nvarchar](2000) NULL,
NET_AMOUNT_FOREIGN [nvarchar](2000) NULL,
NON_POSTING_LINE [nvarchar](2000) NULL,
NUMBER_BILLED [nvarchar](2000) NULL,
OPERATION_SEQUENCE_NUMBER [nvarchar](2000) NULL,
ORDER_PRIORITY [nvarchar](2000) NULL,
PAYMENT_METHOD_ID [nvarchar](2000) NULL,
PAYROLL_ITEM_ID [nvarchar](2000) NULL,
PAYROLL_WAGE_BASE_AMOUNT [nvarchar](2000) NULL,
PAYROLL_YEAR_TO_DATE_AMOUNT [nvarchar](2000) NULL,
PERIOD_CLOSED [nvarchar](2000) NULL,
PRICE_TYPE_ID [nvarchar](2000) NULL,
PROJECT_TASK_ID [nvarchar](2000) NULL,
PURCHASE_CONTRACT_ID [nvarchar](2000) NULL,
QUANTITY_COMMITTED [nvarchar](2000) NULL,
QUANTITY_PACKED [nvarchar](2000) NULL,
QUANTITY_PICKED [nvarchar](2000) NULL,
QUANTITY_RECEIVED_IN_SHIPMENT [nvarchar](2000) NULL,
RECEIVEBYDATE [nvarchar](2000) NULL,
REIMBURSEMENT_TYPE [nvarchar](2000) NULL,
RELATED_ASSET_ID [nvarchar](2000) NULL,
RELATED_COMPANY_ID [nvarchar](2000) NULL,
REVENUE_ELEMENT_ID [nvarchar](2000) NULL,
REV_REC_END_DATE [nvarchar](2000) NULL,
REV_REC_RULE_ID [nvarchar](2000) NULL,
REV_REC_START_DATE [nvarchar](2000) NULL,
RO_CUSTOMIZATION_DETAIL_ID [nvarchar](2000) NULL,
RO_IRS_ASSEMBLY_UNBUILD_ID [nvarchar](2000) NULL,
RO_IS_BATCH [nvarchar](2000) NULL,
RO_IS_SERVICE_CHARGE [nvarchar](2000) NULL,
RO_LINEEDITOR_COREL_ART_EXT_L [nvarchar](2000) NULL,
RO_LINEEDITOR_LASER_ART_EXT_L [nvarchar](2000) NULL,
RO_LINE_CORRELATION_ID [nvarchar](2000) NULL,
RO_PURCHASE_SKU [nvarchar](2000) NULL,
RO_SALESORDER_LINEITEM_CSG_AP [nvarchar](2000) NULL,
RO_SALESORDER_LINEITEM_CSG_FL [nvarchar](2000) NULL,
RO_SALESORDER_LINEITEM_CUST_ID [nvarchar](2000) NULL,
RO_SALESORDER_LINEITEM_LASER_ [nvarchar](2000) NULL,
RO_SALES_ORDER_BACK_ITEM_ID [nvarchar](2000) NULL,
RO_SALES_ORDER_CDR_NEEDS_SYNC [nvarchar](2000) NULL,
RO_SALES_ORDER_FRONT_ITEM_ID [nvarchar](2000) NULL,
RO_SALES_ORDER_IS_PLACEHOLDER [nvarchar](2000) NULL,
RO_SALES_ORDER_LICENSING_ORG_ [nvarchar](2000) NULL,
RO_SALES_ORDER_LICENSING_OR_ID [nvarchar](2000) NULL,
RO_SALES_ORDER_LINE_ITEM_EMBE [nvarchar](2000) NULL,
RO_SALES_ORDER_LINE_ITEM_IS_C [nvarchar](2000) NULL,
RO_SALES_ORDER_LINE_ITEM_NEED [nvarchar](2000) NULL,
RO_SALES_ORDER_LINE_ITEM_PRE_0 [nvarchar](2000) NULL,
RO_SALES_ORDER_PRODUCT_ID [nvarchar](2000) NULL,
RO_SALES_ORDER_RAMBLER_TOTAL [nvarchar](2000) NULL,
RO_SALES_ORDER_RETRY_LASER_AR [nvarchar](2000) NULL,
RO_SALES_ORDER_UPC_DEFINITI_ID [nvarchar](2000) NULL,
RO_SALES_ORDER_WO_PRD_STATU_ID [nvarchar](2000) NULL,
RO_STITCH_LINE_ITEM_ID [nvarchar](2000) NULL,
SCHEDULE_ID [nvarchar](2000) NULL,
SHIPDATE [nvarchar](2000) NULL,
SHIPMENT_RECEIVED [nvarchar](2000) NULL,
SHIPPING_GROUP_ID [nvarchar](2000) NULL,
SIDE_ID [nvarchar](2000) NULL,
SOURCE_SUBSIDIARY_ID [nvarchar](2000) NULL,
SUBSCRIPTION_LINE_ID [nvarchar](2000) NULL,
SUBSIDIARY_ID [nvarchar](2000) NULL,
TAX_ITEM_ID [nvarchar](2000) NULL,
TAX_TYPE [nvarchar](2000) NULL,
TERM_IN_MONTHS [nvarchar](2000) NULL,
TOBEEMAILED [nvarchar](2000) NULL,
TOBEFAXED [nvarchar](2000) NULL,
TOBEPRINTED [nvarchar](2000) NULL,
TRANSACTION_DISCOUNT_LINE [nvarchar](2000) NULL,
TRANSACTION_ID [nvarchar](2000) NULL,
TRANSACTION_LINE_ID [nvarchar](2000) NULL,
TRANSACTION_ORDER [nvarchar](2000) NULL,
TRANSFER_ORDER_ITEM_LINE [nvarchar](2000) NULL,
TRANSFER_ORDER_LINE_TYPE [nvarchar](2000) NULL,
UNIQUE_KEY [nvarchar](2000) NULL,
UNIT_COST_OVERRIDE [nvarchar](2000) NULL,
UNIT_OF_MEASURE_ID [nvarchar](2000) NULL,
VSOE_ALLOCATION [nvarchar](2000) NULL,
VSOE_AMT [nvarchar](2000) NULL,
VSOE_DEFERRAL [nvarchar](2000) NULL,
VSOE_DELIVERED [nvarchar](2000) NULL,
VSOE_DISCOUNT [nvarchar](2000) NULL,
VSOE_PRICE [nvarchar](2000) NULL,
dw_last_updt datetime null
)
WITH (DATA_SOURCE = [AzureDataLakeStoreyetidpe3600],LOCATION = N'/hive/warehouse/edw_sz.db/nst_transaction_lines',FILE_FORMAT = [AzureStorageFormatHiveText],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
;


if object_id('EDW_SZ.NST_Transaction_Lines') is not null begin
Drop TABLE EDW_SZ.NST_Transaction_Lines end;
Create Table EDW_SZ.NST_Transaction_Lines WITH (DISTRIBUTION = ROUND_ROBIN ) AS 
(
Select 
ACCOUNT_ID,
ALT_SALES_AMOUNT,
AMORTIZATION_RESIDUAL,
AMOUNT,
AMOUNT_FOREIGN,
AMOUNT_FOREIGN_LINKED,
AMOUNT_LINKED,
AMOUNT_PENDING,
AMOUNT_SETTLEMENT,
AMOUNT_TAXABLE,
AMOUNT_TAXED,
BILL_VARIANCE_STATUS,
BILLING_SCHEDULE_ID,
BOM_QUANTITY,
CATCH_UP_PERIOD_ID,
CHARGE_TYPE,
CLASS_ID,
COMPANY_ID,
COMPONENT_ID,
COMPONENT_YIELD,
COST_ESTIMATE_TYPE,
DATE_CLEARED,
DATE_CLOSED,
DATE_CREATED,
DATE_LAST_MODIFIED,
DATE_LAST_MODIFIED_GMT,
DATE_REVENUE_COMMITTED,
DELAY_REV_REC,
DEPARTMENT_ID,
DO_NOT_DISPLAY_LINE,
DO_NOT_PRINT_LINE,
DO_RESTOCK,
ESTIMATED_COST,
ESTIMATED_COST_FOREIGN,
EXPECTED_RECEIPT_DATE,
EXPENSE_CATEGORY_ID,
GL_NUMBER,
GL_SEQUENCE,
GL_SEQUENCE_ID,
GROSS_AMOUNT,
HAS_COST_LINE,
IS_ALLOCATION,
IS_AMORTIZATION_REV_REC,
IS_COMMITMENT_CONFIRMED,
IS_COST_LINE,
IS_CUSTOM_LINE,
IS_EXCLUDE_FROM_RATE_REQUEST,
IS_FX_VARIANCE,
IS_ITEM_VALUE_ADJUSTMENT,
IS_LANDED_COST,
IS_SCRAP,
IS_VSOE_ALLOCATION_LINE,
ISBILLABLE,
ISCLEARED,
ISNONREIMBURSABLE,
ISTAXABLE,
Cast(CAST(Case when Replace(ITEM_COUNT,'-','') = 'null' then null else Replace(ITEM_COUNT,'-','') END As Decimal(10,1)) AS Int) AS ITEM_COUNT,
Cast(CAST(Case when Item_Id = 'null' then null else Item_Id END As Decimal(10,1)) AS Int) AS Item_Id,
ITEM_RECEIVED,
ITEM_SOURCE,
ITEM_UNIT_PRICE,
KIT_PART_NUMBER,
LANDED_COST_SOURCE_LINE_ID,
LOCATION_ID,
MATCH_BILL_TO_RECEIPT,
NEEDS_REVENUE_ELEMENT,
NET_AMOUNT,
NET_AMOUNT_FOREIGN,
NON_POSTING_LINE,
NUMBER_BILLED,
OPERATION_SEQUENCE_NUMBER,
ORDER_PRIORITY,
PAYMENT_METHOD_ID,
PAYROLL_ITEM_ID,
PAYROLL_WAGE_BASE_AMOUNT,
PAYROLL_YEAR_TO_DATE_AMOUNT,
PERIOD_CLOSED,
PRICE_TYPE_ID,
PROJECT_TASK_ID,
PURCHASE_CONTRACT_ID,
QUANTITY_COMMITTED,
QUANTITY_PACKED,
QUANTITY_PICKED,
QUANTITY_RECEIVED_IN_SHIPMENT,
RECEIVEBYDATE,
REIMBURSEMENT_TYPE,
RELATED_ASSET_ID,
RELATED_COMPANY_ID,
REV_REC_END_DATE,
REV_REC_RULE_ID,
REV_REC_START_DATE,
REVENUE_ELEMENT_ID,
RO_CUSTOMIZATION_DETAIL_ID,
RO_IRS_ASSEMBLY_UNBUILD_ID,
RO_IS_BATCH,
RO_IS_SERVICE_CHARGE,
RO_LINE_CORRELATION_ID,
RO_LINEEDITOR_COREL_ART_EXT_L,
RO_LINEEDITOR_LASER_ART_EXT_L,
RO_PURCHASE_SKU,
RO_SALES_ORDER_BACK_ITEM_ID,
RO_SALES_ORDER_CDR_NEEDS_SYNC,
Cast(CAST(Case when RO_SALES_ORDER_FRONT_ITEM_ID = 'null' then null else RO_SALES_ORDER_FRONT_ITEM_ID END As Decimal(10,1)) AS Int) AS RO_SALES_ORDER_FRONT_ITEM_ID,
RO_SALES_ORDER_IS_PLACEHOLDER,
RO_SALES_ORDER_LICENSING_OR_ID,
RO_SALES_ORDER_LICENSING_ORG_,
RO_SALES_ORDER_LINE_ITEM_EMBE,
RO_SALES_ORDER_LINE_ITEM_IS_C,
RO_SALES_ORDER_LINE_ITEM_NEED,
RO_SALES_ORDER_LINE_ITEM_PRE_0,
RO_SALES_ORDER_PRODUCT_ID,
CAST(Case when RO_SALES_ORDER_RAMBLER_TOTAL = 'null' then null else RO_SALES_ORDER_RAMBLER_TOTAL END As Decimal(25,2)) AS RO_SALES_ORDER_RAMBLER_TOTAL,
RO_SALES_ORDER_RETRY_LASER_AR,
RO_SALES_ORDER_UPC_DEFINITI_ID,
RO_SALES_ORDER_WO_PRD_STATU_ID,
RO_SALESORDER_LINEITEM_CSG_AP,
RO_SALESORDER_LINEITEM_CSG_FL,
RO_SALESORDER_LINEITEM_CUST_ID,
RO_SALESORDER_LINEITEM_LASER_,
RO_STITCH_LINE_ITEM_ID,
SCHEDULE_ID,
CAST(case when SHIPDATE in ('\N','null') then Null else SHIPDATE end AS Datetime) As SHIPDATE,
CAST(case when SHIPMENT_RECEIVED in ('\N','null') then Null else SHIPMENT_RECEIVED end As Datetime) As SHIPMENT_RECEIVED,
SHIPPING_GROUP_ID,
SIDE_ID,
SOURCE_SUBSIDIARY_ID,
SUBSCRIPTION_LINE_ID,
SUBSIDIARY_ID,
TAX_ITEM_ID,
TAX_TYPE,
TERM_IN_MONTHS,
TOBEEMAILED,
TOBEFAXED,
TOBEPRINTED,
TRANSACTION_DISCOUNT_LINE,
TRANSACTION_ID,
TRANSACTION_LINE_ID,
TRANSACTION_ORDER,
TRANSFER_ORDER_ITEM_LINE,
TRANSFER_ORDER_LINE_TYPE,
UNIQUE_KEY,
UNIT_COST_OVERRIDE,
UNIT_OF_MEASURE_ID,
VSOE_ALLOCATION,
VSOE_AMT,
VSOE_DEFERRAL,
VSOE_DELIVERED,
VSOE_DISCOUNT,
VSOE_PRICE
 from EDW_RZ.NST_Transaction_Lines 
);

GO
