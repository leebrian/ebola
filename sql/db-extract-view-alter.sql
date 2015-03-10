USE [EbolaQC]
GO

/****** Object:  View [dbo].[DBExtractView]    Script Date: 3/2/2015 10:13:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[DBExtractView]
AS
SELECT        dbo.Database_Extraction_2015_03_08$.*
FROM            dbo.Database_Extraction_2015_03_08$

GO


