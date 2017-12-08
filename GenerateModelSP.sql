USE ContosoRetailDW;
GO

CREATE OR ALTER PROCEDURE spGenerateModel @Script NVARCHAR(MAX), @InputData NVARCHAR(MAX), @InputDataName NVARCHAR(128), @OutputDataName NVARCHAR(128), @ModelName NVARCHAR(20)
AS
BEGIN

DECLARE @Model VARBINARY(MAX)


EXECUTE SP_EXECUTE_EXTERNAL_SCRIPT
		@LANGUAGE = N'R'
		,@SCRIPT = @script
		,@input_data_1 = @InputData
		,@input_data_1_name = @InputDataName
		,@output_data_1_name = @OutputDataName
		,@params = 
			N'@ModelName NVARCHAR(20) OUTPUT
			,@Model VARBINARY(MAX) OUTPUT'
		,@ModelName = @ModelName OUTPUT
		,@Model = @Model OUTPUT;
INSERT INTO ContosoRetailDW.dbo.Models
(
	ModelName
	,Model
)
VALUES
(
	@ModelName
	,@Model
)

END
GO