function Get-LbryBlob() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[Alias('blob_hash')]
		[String]$BlobHash,
		[Parameter(Mandatory = $false)]
		[Int]$Timeout,
		[Parameter(Mandatory = $false)]
		[ValidateSet('json')]
		[String]$Encoding,
		[Parameter(Mandatory = $false)]
		[Alias('payment_rate_manager')][String]$PaymentRateManager
	)
	begin { $method = "blob_get" }
	process {
		$params = @{
			blob_hash  = $BlobHash
		}
		if ($Timeout) {
			$params.Add("timeout", $Timeout)
		}
		if ($Encoding) {
			$params.Add("encoding", $Encoding)
		}
		if ($PaymentRateManager) {
			$params.Add("payment_rate_manager", $PaymentRateManager)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryBlobDescriptor() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[Alias('sd_hash')][String]$SdHash,
		[Parameter(Mandatory = $false)]
		[Int]$Timeout,
		[Parameter(Mandatory = $false)]
		[Alias('payment_rate_manager')][String]$PaymentRateManager
	)
	begin { $method = "descriptor_get" }
	process {
		$params = @{
			blob_hash = $BlobHash
		}
		if ($Timeout) {
			$params.Add("timeout", $Timeout)
		}
		if ($PaymentRateManager) {
			$params.Add("payment_rate_manager", $PaymentRateManager)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryBlobHash() {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ParameterSetName = 'all')]
		[Switch]$All,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'uri')]
		[String]$Uri,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'stream_hash')]
		[Alias('stream_hash')][String]$StreamHash,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'sd_hash')]
		[Alias('sd_hash')][String]$SdHash,
		[Parameter(Mandatory = $false, ParameterSetName = 'uri')]
		[Parameter(Mandatory = $false, ParameterSetName = 'stream_hash')]
		[Parameter(Mandatory = $false, ParameterSetName = 'sd_hash')]
		[Boolean]$Needed,
		[Parameter(Mandatory = $false, ParameterSetName = 'uri')]
		[Parameter(Mandatory = $false, ParameterSetName = 'stream_hash')]
		[Parameter(Mandatory = $false, ParameterSetName = 'sd_hash')]
		[Boolean]$Finished,
		[Parameter(Mandatory = $false, ParameterSetName = 'uri')]
		[Parameter(Mandatory = $false, ParameterSetName = 'stream_hash')]
		[Parameter(Mandatory = $false, ParameterSetName = 'sd_hash')]
		[Alias('page_size')][Int]$PageSize,
		[Parameter(Mandatory = $false, ParameterSetName = 'uri')]
		[Parameter(Mandatory = $false, ParameterSetName = 'stream_hash')]
		[Parameter(Mandatory = $false, ParameterSetName = 'sd_hash')]
		[Int]$Page
	)
	begin { $method = "blob_list" }
	process {
		if ($all) {
			Get-LbryJsonContent -method $method
			Return
		}
		$set = $PSCmdlet.ParameterSetName
		if ($set -eq "uri") {
			$params = @{
				uri	    = $Uri
			}
		}
		if ($set -eq "stream_hash") {
			$params = @{
				stream_hash	    = $StreamHash
			}
		}
		if ($set -eq "sd_hash") {
			$params = @{
				sd_hash	    = $SdHash
			}
		}
		if ($Needed) {
			$params.Add("needed", $Needed)
		}
		if ($Finished) {
			$params.Add("finished", $Finished)
		}
		if ($PageSize) {
			$params.Add("page_size", $PageSize)
		}
		if ($Page) {
			$params.Add("page", $Page)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryBlobPeer() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline = $true, Position = 0, Mandatory = $true)]
		[String]$BlobHash,
		[Parameter(Position = 1, Mandatory = $false)]
		[Int]$Timeout
	)
	begin { $method = "peer_list" }
	process {
		$params = @{
			blob_hash	  = $BlobHash
		}
		if ($Timeout) {
			$params.Add("timeout", $Timeout)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Remove-LbryBlob() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[Alias('blob_hash')]
		[String]$BlobHash
	)
	begin { $method = "blob_delete" }
	process {
		$params = @{
			blob_hash	  = $BlobHash
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryBlock() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true, ParameterSetName = 'blockhash')]
		[String]$BlockHash,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = 'height')]
		[String]$Height
	)
	begin { $method = "block_show" }
	process {
		$set = $PSCmdlet.ParameterSetName
		if ($set -eq "blockhash") {
			$params = @{
				blockhash	  = $BlockHash
			}
		} else {
			$params = @{
				height	   = $Height
			}
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Sync-LbryBlob() {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, ParameterSetName = "announce_all")]
		[Switch]$AnnounceAll = $false,
		[Parameter(Mandatory = $true, ParameterSetName = "reflect_all")]
		[Switch]$ReflectAll = $false
	)
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq $AnnounceAll) {
		$method = "blob_announce_all"
	}
	if ($set -eq $ReflectAll) {
		$method = "blob_reflect_all"
	}
	Get-LbryJsonContent -Method $method
}
function New-LbryBugReport() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline = $true, Position = 0, Mandatory = $true)]
		[String]$Message
	)
	begin { $method = "report_bug" }
	process {
		$params = @{
			message    = $Message
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryChannel() {
	[CmdletBinding()]
	$method = "channel_list_mine"
	Get-LbryJsonContent -Method $method
}
function New-LbryChannel() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[Alias('channel_name')][String]$ChannelName,
		[Parameter(Position = 1, Mandatory = $true)]
		[Float]$Amount
	)
	begin { $method = "channel_new" }
	process {
		$params = @{
			channel_name	 = $ChannelName
			amount		     = $Amount
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Add-LbryClaimSupport() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$Name,
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 1, Mandatory = $true)]
		[Alias('claim_id')][String]$ClaimId,
		[Parameter(Position = 2, Mandatory = $true)]
		[Float]$Amount
	)
	begin { $method = "claim_new_support" }
	process {
		$params = @{
			name		 = $Name
			claim_id	 = $ClaimId
			amount	     = $Amount
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryClaim() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true, ParameterSetName = "name")]
		[String]$Name,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "txid")]
		[String]$Txid,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "claim_id")]
		[Alias('claim_id')][String]$ClaimId,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false, ParameterSetName = "name")]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false, ParameterSetName = "txid")]
		[String]$Nout,
		[Parameter(Mandatory = $true, ParameterSetName = "mine")]
		[Switch]$Mine = $false,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "channel")]
		[Alias('channel_name')][String]$ChannelName,
		[Parameter(Mandatory = $false, ParameterSetName = "channel")]
		[Int]$Page,
		[Parameter(Mandatory = $false, ParameterSetName = "channel")]
		[Alias('page_size')][Int]$PageSize
	)
	process {
		$set = $PSCmdlet.ParameterSetName
		if ($set -eq "name") {
			$method = "claim_show"
			$params = @{
				name    = $Name
			}
			if ($Nout) {
				$params.Add("nout", $Nout)
			}
		}
		if ($set -eq "txid") {
			$method = "claim_show"
			$params = @{
				txid	 = $Txid
			}
		}
		if ($set -eq "claim_id") {
			$method = "claim_show"
			$params = @{
				claim_id	 = $ClaimId
			}
		}
		if ($set -eq "mine") {
			$method = "claim_list_mine"
			Get-LbryJsonContent -Method $method
			Return
		}
		if ($set -eq "channel") {
			$method = "claim_list_by_channel"
			$params = @{
				uri	    = $ChannelName
			}
			$test = Get-LbryJsonContent -Method $method -Params $params
			if ($test.$ChannelName.error) {
				Write-Error $test.$ChannelName.error
				Return
			}
			if ($PageSize) {
				$params.Add("page_size", $PageSize)
			}
			if ($Page) {
				$params.Add("page", $Page)
				$result = Get-LbryJsonContent -Method $method -Params $params
				$result.$ChannelName.claims_in_channel
			} else {
				$result = Get-LbryJsonContent -Method $method -Params $params
				$totalPgs = $result.$ChannelName.claims_in_channel_pages
				$pgs = 1 .. $totalPgs
				$params.Add("page", "1")
				foreach ($pg in $pgs) {
					$params["page"] = $pg
					$result = Get-LbryJsonContent -Method $method -Params $params
					$result.$ChannelName.claims_in_channel
				}
			}
			Return
		}
		$result = Get-LbryJsonContent -Method $method -Params $params
		$result.claim
	}
}
function New-LbryClaim() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$Name,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[Float]$Bid = "1",
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[HashTable[]]$Metadata,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('file_path')][String]$FilePath,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[HashTable]$Fee,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$Title,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$Description,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$Author,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$Language = "en",
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[String]$License = "Creative Commons",
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('license_url')]
		[String]$LicenseUrl,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[String]$Thumbnail,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[String]$Preview,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[Boolean]$Nsfw = $true,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[HashTable]$sources,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('channel_name')][String]$ChannelName
	)
	begin { $method = "publish" }
	process {
		$params = @{
			name		    = $Name
			bid			    = $Bid
			title		    = $Title
			description	    = $Description
			author		    = $Author
			language	    = $Language
			license		    = $License
			nsfw		    = $Nsfw
		}
		if ($Metadata) {
			$params.Add("metadata", $Metadata)
		}
		if ($FilePath) {
			$params.Add("file_path", $FilePath)
		}
		if ($Fee) {
			$params.Add("fee", $Fee)
		}
		if ($LicenseUrl) {
			$params.Add("license_url", $LicenseUrl)
		}
		if ($Thumbnail) {
			$params.Add("thumbnail", $Thumbnail)
		}
		if ($Preview) {
			$params.Add("preview", $Preview)
		}
		if ($sources) {
			$params.Add("sources", $sources)
		}
		if ($ChannelName) {
			$params.Add("channel_name", $ChannelName)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Remove-LbryClaim() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[Alias('claim_id')][String]$ClaimId
	)
	begin { $method = "claim_abandon" }
	process {
		$params = @{
			claim_id	 = $ClaimId
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryDaemon() {
	$method = "settings_get"
	Get-LbryJsonContent -Method $method
}
function Get-LbryDaemonStatus() {
	[CmdletBinding()]
	param (
		[Parameter(Position = 0, Mandatory = $false)]
		[Alias('session_status')]
		[Switch]$SessionStatus
	)
	begin { $method = "status" }
	process {
		if ($SessionStatus) {
			$params = @{
				session_status	   = $SessionStatus
			}
			Get-LbryJsonContent -Method $method -Params $params
			Return
		}
		Get-LbryJsonContent -Method $method
	}
}
function Set-LbryDaemon() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('run_on_startup')]
		[Boolean]$RunOnStartup,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('data_rate')]
		[Float]$DataRate,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('max_key_fee')]
		[Float]$MaxKeyFee,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('download_directory')]
		[String]$DownloadDirectory,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('max_upload')]
		[Float]$MaxUpload,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('max_download')]
		[Float]$MaxDownload,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('download_timeout')]
		[Int]$DownloadTimeout,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('search_timeout')]
		[Float]$SearchTimeout,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('cache_time')]
		[Int]$CacheTime
	)
	begin { $method = "settings_set" }
	process {
		$params = @{ }
		if ($RunOnStartup) {
			$params.Add("run_on_startup", $RunOnStartup)
		}
		if ($DataRate) {
			$params.Add("data_rate", $DataRate)
		}
		if ($MaxKeyFee) {
			$params.Add("max_key_fee", $MaxKeyFee)
		}
		if ($DownloadDirectory) {
			$params.Add("download_directory", $DownloadDirectory)
		}
		if ($MaxUpload) {
			$params.Add("max_upload", $MaxUpload)
		}
		if ($MaxDownload) {
			$params.Add("max_download", $MaxDownload)
		}
		if ($DownloadTimeout) {
			$params.Add("download_timeout", $DownloadTimeout)
		}
		if ($SearchTimeout) {
			$params.Add("search_timeout", $SearchTimeout)
		}
		if ($CacheTime) {
			$params.Add("cache_time", $CacheTime)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Stop-LbryDaemon() {
	[CmdletBinding()]
	$method = "daemon_stop"
	Get-LbryJsonContent -Method $method
}
function Get-LbryFile() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true, ParameterSetName = "name")]
		[String]$Name,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "sd_hash")]
		[Alias('sd_hash')][String]$SdHash,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "file_name")]
		[Alias('file_name')][String]$FileName,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "stream_hash")]
		[Alias('stream_hash')][String]$StreamHash,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "claim_id")]
		[Alias('claim_id')][String]$ClaimId,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "outpoint")]
		[String]$Outpoint,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "rowid")]
		[Int]$Rowid,
		[Parameter(Mandatory = $false, ParameterSetName = "name")]
		[Parameter(Mandatory = $false, ParameterSetName = "sd_hash")]
		[Parameter(Mandatory = $false, ParameterSetName = "file_name")]
		[Parameter(Mandatory = $false, ParameterSetName = "stream_hash")]
		[Parameter(Mandatory = $false, ParameterSetName = "claim_id")]
		[Parameter(Mandatory = $false, ParameterSetName = "outpoint")]
		[Parameter(Mandatory = $false, ParameterSetName = "rowid")]
		[Alias('full_status')]
		[Boolean]$FullStatus
	)
	begin { $method = "file_list" }
	process {
		$set = $PSCmdlet.ParameterSetName
		if ($set -eq "name") {
			$params = @{
				name	 = $Name
			}
		}
		if ($set -eq "sd_hash") {
			$params = @{
				sd_hash	    = $SdHash
			}
		}
		if ($set -eq "file_name") {
			$params = @{
				file_name	  = $FileName
			}
		}
		if ($set -eq "stream_hash") {
			$params = @{
				stream_hash	    = $StreamHash
			}
		}
		if ($set -eq "claim_id") {
			$params = @{
				claim_id	 = $ClaimId
			}
		}
		if ($set -eq "outpoint") {
			$params = @{
				outpoint	 = $Outpoint
			}
		}
		if ($set -eq "rowid") {
			$params = @{
				rowid	  = $Rowid
			}
		}
		if ($FullStatus) {
			$params.Add("full_status", $FullStatus)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Remove-LbryFile() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true, ParameterSetName = "name")]
		[String]$Name,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "sd_hash")]
		[Alias('sd_hash')][String]$SdHash,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "file_name")]
		[Alias('file_name')][String]$FileName,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "stream_hash")]
		[Alias('stream_hash')][String]$StreamHash,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "claim_id")]
		[Alias('claim_id')][String]$ClaimId,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "outpoint")]
		[String]$Outpoint,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "rowid")]
		[Int]$Rowid,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false, ParameterSetName = "name")]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false, ParameterSetName = "sd_hash")]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false, ParameterSetName = "file_name")]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false, ParameterSetName = "stream_hash")]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false, ParameterSetName = "claim_id")]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false, ParameterSetName = "outpoint")]
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false, ParameterSetName = "rowid")]
		[Boolean]$delete_target_file
	)
	begin { $method = "file_delete" }
	process {
		$set = $PSCmdlet.ParameterSetName
		if ($set -eq "name") {
			$params = @{
				name	 = $Name
			}
		}
		if ($set -eq "sd_hash") {
			$params = @{
				sd_hash	    = $SdHash
			}
		}
		if ($set -eq "file_name") {
			$params = @{
				file_name	  = $FileName
			}
		}
		if ($set -eq "stream_hash") {
			$params = @{
				stream_hash	    = $StreamHash
			}
		}
		if ($set -eq "claim_id") {
			$params = @{
				claim_id	 = $ClaimId
			}
		}
		if ($set -eq "outpoint") {
			$params = @{
				outpoint	 = $Outpoint
			}
		}
		if ($set -eq "rowid") {
			$params = @{
				rowid	  = $Rowid
			}
		}
		if ($delete_target_file) {
			$params.Add("delete_target_file", $delete_target_file)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Start-LbryFileDownload() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true, ParameterSetName = "name")]
		[String]$Name,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "sd_hash")]
		[Alias('sd_hash')][String]$SdHash,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "file_name")]
		[Alias('file_name')][String]$FileName
	)
	begin { $method = "file_set_status" }
	process {
		$set = $PSCmdlet.ParameterSetName
		$params = @{
			status	   = "start"
		}
		if ($set -eq "name") {
			$params.Add("name", $Name)
		}
		if ($set -eq "sd_hash") {
			$params.Add("sd_hash", $SdHash)
		}
		if ($set -eq "file_name") {
			$params.Add("file_name", $FileName)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Stop-LbryFileDownload() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true, ParameterSetName = "name")]
		[String]$Name,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "sd_hash")]
		[Alias('sd_hash')][String]$SdHash,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "file_name")]
		[Alias('file_name')][String]$FileName
	)
	begin { $method = "file_set_status" }
	process {
		$set = $PSCmdlet.ParameterSetName
		$params = @{
			status	   = "stop"
		}
		if ($set -eq "name") {
			$params.Add("name", $Name)
		}
		if ($set -eq "sd_hash") {
			$params.Add("sd_hash", $SdHash)
		}
		if ($set -eq "file_name") {
			$params.Add("file_name", $FileName)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryJsonContent() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$Method,
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 1, Mandatory = $false)]
		[Hashtable]$Params
	)
	begin { $uri = "http://localhost:5279/lbryapi" }
	process {
		if (($params -eq "") -or ($params -eq $null)) {
			$data = ConvertTo-Json @{
				method	   = $Method
			}
		} else {
			$data = ConvertTo-Json @{
				method	   = $Method; params = $Params
			}
		}
		Write-Verbose $data
		$output = Invoke-WebRequest -uri $uri -Method Post -Body $data
		$content = ConvertFrom-Json $output.Content
		$content.result
	}
}
function Get-LbryStream() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline = $true, Position = 0, Mandatory = $true)]
		[String]$Uri,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('file_name')][String]$FileName,
		[Parameter(Mandatory = $false)]
		[Int]$Timeout,
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[Alias('download_directory')]
		[String]$DownloadDirectory,
		[Parameter(Mandatory = $false)]
		[Switch]$Show
	)
	begin { $method = "get" }
	process {
		$params = @{
			uri	      = $Uri
		}
		if ($FileName) {
			$params.Add("file_name", $FileName)
		}
		if ($Timeout) {
			$params.Add("timeout", $Timeout)
		}
		if ($DownloadDirectory) {
			$params.Add("download_directory", $DownloadDirectory)
		}
		$available = Get-LbryStreamAvailability $Uri
		if ($available -eq "0.0" -or [String]::IsNullOrWhiteSpace($available)) {
			Write-Error "Stream is not available"
			Break
		}
		$cost = Get-LbryStreamCostEstimate $Uri
		if ($cost -ne "0.0") {
			$Title = "Payment Required"
			$Message = "Confirm Payment: `"$cost`" LBC?"
			$yes = New-Object System.Management.Automation.Host.Choicedescription "&Yes", `
							  "Pay and download stream."
			$no = New-Object System.Management.Automation.Host.Choicedescription "&No", `
							 "Refuse payment and exit."
			$options = [System.Management.Automation.Host.Choicedescription[]]($yes, $no)
			$pay = $host.ui.PromptForChoice($Title, $Message, $options, 0)
			if ($pay -eq 1) {
				Return
			}
		}
		if ($Show) {
			$result = Get-LbryJsonContent -Method $method -Params $params
			$result
			Start-Process -FilePath $result.download_path
		} else {
			Get-LbryJsonContent -Method $method -Params $params
		}
	}
}
function Get-LbryStreamAvailability() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$Uri,
		[Parameter(Mandatory = $false)]
		[Alias('sd_timeout')]
		[Int]$SdTimeout,
		[Parameter(Mandatory = $false)]
		[Alias('peer_timeout')]
		[Int]$PeerTimeout
	)
	begin { $method = "get_availability" }
	process {
		$params = @{
			uri	= $Uri
		}
		if ($SdTimeout) {
			$params.Add("sd_timeout", $SdTimeout)
		}
		if ($PeerTimeout) {
			$params.Add("peer_timeout", $PeerTimeout)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Sync-LbryStream() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[Alias('sd_hash')][String]$SdHash
	)
	begin { $method = "reflect" }
	process {
		$params = @{
			sd_hash	    = $SdHash
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryStreamCostEstimate() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$Uri,
		[Parameter(Mandatory = $false)]
		[Int]$Size
	)
	begin { $method = "stream_cost_estimate" }
	process {
		$params = @{
			uri	    = $Uri
		}
		if ($Size) {
			$params.Add("size", $Size)
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Resolve-LbryStream() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$Name
	)
	begin { $method = "resolve_name" }
	process {
		$params = @{
			name	 = $Name
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryTransaction() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true, ParameterSetName = "txid")]
		[String]$Txid,
		[Parameter(Mandatory = $true, ParameterSetName = "wallet")]
		[Switch]$Wallet
	)
	process {
		if ($Wallet) {
			$method = "transaction_list"
			Get-LbryJsonContent -Method $method
			Return
		} else {
			$method = "transaction_show"
			$params = @{
				txid	 = $Txid
			}
			Get-LbryJsonContent -Method $method -Params $params
		}
	}
}
function Resolve-LbryUri() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$Uri
	)
	$params = @{
		uri	    = $Uri
	}
	begin { $method = "resolve" }
	process {
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryVersion() {
	[CmdletBinding()]
	$method = "version"
	Get-LbryJsonContent -Method $method
}
function Get-LbryWalletAddressList() {
	[CmdletBinding()]
	$method = "wallet_list"
	Get-LbryJsonContent -Method $method
}
function Get-LbryWalletAddressUnused() {
	[CmdletBinding()]
	$method = "wallet_unused_address"
	Get-LbryJsonContent -Method $method
}
function New-LbryWalletAddress() {
	[CmdletBinding()]
	$method = "wallet_new_address"
	Get-LbryJsonContent -Method $method
}
function Get-LbryWalletBalance() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $false)]

		[String]$Address,
		[Parameter(Position = 1, Mandatory = $false)]
		[Alias('include_unconfirmed')]
		[Boolean]$IncludeUnconfirmed
	)
	begin { $method = "wallet_balance" }
	process {
		if ($Address) {
			$params = @{
				address	    = $Address
			}
			if ($IncludeUnconfirmed) {
				$params.Add("include_unconfimed", $IncludeUnconfirmed)
			}
			Get-LbryJsonContent -Method $method -Params $params
			Return
		} else {
			Get-LbryJsonContent -Method $method
		}
	}
}
function Send-LbryWalletCredits() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$Address,
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 1, Mandatory = $true)]
		[Float]$Amount
	)
	begin { $method = "send_amount_to_address" }
	process {
		$params = @{
			amount	   = $Amount
		}
		$params.Add("address", $Address)
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryWalletPublicKey() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$Address
	)
	begin { $method = "wallet_public_key" }
	process {
		$params = @{
			address	    = $Address
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}
function Get-LbryWalletTransactionList() {
	[CmdletBinding()]
	$method = "transaction_list"
	Get-LbryJsonContent -Method $method
}
function Test-LbryWalletAddressOwnership() {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0, Mandatory = $true)]
		[String]$Address
	)
	begin { $method = "wallet_is_address_mine" }
	process {
		$params = @{
			address	    = $Address
		}
		Get-LbryJsonContent -Method $method -Params $params
	}
}