function Get-LbryBlob() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$BlobHash,
		[Parameter(Mandatory = $false)]
		[Int]$Timeout,
		[Parameter(Mandatory = $false)]
		[ValidateSet('json')]
		[String]$Encoding,
		[Parameter(Mandatory = $false)]
		[String]$PaymentRateManager
	)
	$method = "blob_get"
	$params = @{
		blob_hash = $BlobHash
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
function Get-LbryBlobDescriptor() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$SdHash,
		[Parameter(Mandatory = $false)]
		[Int]$Timeout,
		[Parameter(Mandatory = $false)]
		[String]$PaymentRateManager
	)
	$method = "descriptor_get"
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
function Get-LbryBlobHash() {
	param (
		[Parameter(Position = 0, Mandatory = $false, ParameterSetName = 'All')]
		[Switch]$All = $false,
		[Parameter(Mandatory = $false, ParameterSetName = 'Uri')]
		[String]$Uri,
		[Parameter(Mandatory = $false, ParameterSetName = 'StreamHash')]
		[String]$StreamHash,
		[Parameter(Mandatory = $false, ParameterSetName = 'SdHash')]
		[String]$SdHash,
		[Parameter(Mandatory = $false, ParameterSetName = 'Uri')]
		[Parameter(Mandatory = $false, ParameterSetName = 'StreamHash')]
		[Parameter(Mandatory = $false, ParameterSetName = 'SdHash')]
		[Boolean]$Needed,
		[Parameter(Mandatory = $false, ParameterSetName = 'Uri')]
		[Parameter(Mandatory = $false, ParameterSetName = 'StreamHash')]
		[Parameter(Mandatory = $false, ParameterSetName = 'SdHash')]
		[Boolean]$Finished,
		[Parameter(Mandatory = $false, ParameterSetName = 'Uri')]
		[Parameter(Mandatory = $false, ParameterSetName = 'StreamHash')]
		[Parameter(Mandatory = $false, ParameterSetName = 'SdHash')]
		[Int]$PageSize,
		[Parameter(Mandatory = $false, ParameterSetName = 'Uri')]
		[Parameter(Mandatory = $false, ParameterSetName = 'StreamHash')]
		[Parameter(Mandatory = $false, ParameterSetName = 'SdHash')]
		[Int]$Page
	)
	$method = "blob_list"
	if ($All) {
		Get-LbryJsonContent -method $method
		Return
	}
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq "Uri") {
		$params = @{
			uri = $Uri
		}
	}
	if ($set -eq "StreamHash") {
		$params = @{
			stream_hash = $StreamHash
		}
	}
	if ($set -eq "SdHash") {
		$params = @{
			sd_hash = $SdHash
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
function Get-LbryBlobPeer() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$BlobHash,
		[Parameter(Mandatory = $false)]
		[Int]$Timeout
	)
	$method = "peer_list"
	$params = @{
		blob_hash = $BlobHash
	}
	if ($Timeout) {
		$params.Add("timeout", $Timeout)
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Remove-LbryBlob() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$BlobHash
	)
	$method = "blob_delete"
	$params = @{
		blob_hash = $BlobHash
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryBlock() {
	param (
		[Parameter(Position = 0, Mandatory = $true, ParameterSetName = 'Blockhash')]
		[String]$Blockhash,
		[Parameter(Mandatory = $true, ParameterSetName = 'Height')]
		[String]$Height
	)
	
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq "Blockhash") {
		$params = @{
			blockhash = $blockhash
		}
	} else {
		$params = @{
			height = $Height
		}
	}
	
	$method = "block_show"
	Get-LbryJsonContent -Method $method -Params $params
}
function Sync-LbryBlob() {
	param (
		[Parameter(Mandatory = $true, ParameterSetName = "AnnounceAll")]
		[Switch]$AnnounceAll = $false,
		[Parameter(Mandatory = $true, ParameterSetName = "ReflectAll")]
		[Switch]$ReflectAll = $false
	)
	if ($AnnounceAll) {
		$method = "blob_announce_all"
	}
	if ($ReflectAll) {
		$method = "blob_reflect_all"
	}
	Get-LbryJsonContent -Method $method
}
function New-LbryBugReport() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Message
	)
	$params = @{
		message = $Message
	}
	$method = "report_bug"
	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryChannel() {
	$method = "channel_list_mine"
	Get-LbryJsonContent -Method $method
}
function New-LbryChannel() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$ChannelName,
		[Parameter(Position = 1, Mandatory = $true)]
		[float]$Amount
	)
	$method = "channel_new"
	$params = @{
		channel_name = $ChannelName
		amount	     = $Amount
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Add-LbryClaimSupport() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Name,
		[Parameter(Position = 1, Mandatory = $true)]
		[String]$ClaimId,
		[Parameter(Position = 2, Mandatory = $true)]
		[float]$Amount
	)
	$method = "claim_new_support"
	$params = @{
		name   = $Name
		claim_id = $ClaimID
		amount   = $Amount
	}

	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryClaim() {
	param (
		[Parameter(Position = 0, Mandatory = $true, ParameterSetName = "Name")]
		[String]$Name,
		[Parameter(Mandatory = $true, ParameterSetName = "Txid")]
		[String]$Txid,
		[Parameter(Mandatory = $true, ParameterSetName = "ClaimId")]
		[String]$ClaimId,
		[Parameter(Mandatory = $false, ParameterSetName = "Name")]
		[Parameter(Mandatory = $false, ParameterSetName = "Txid")]
		[String]$Nout,
		[Parameter(Mandatory = $true, ParameterSetName = "Mine")]
		[Switch]$Mine = $false,
		[Parameter(Mandatory = $true, ParameterSetName = "Channel")]
		[String]$Uri,
		[Parameter(Mandatory = $false, ParameterSetName = "Channel")]
		[Int]$Page,
		[Parameter(Mandatory = $false, ParameterSetName = "Channel")]
		[Int]$PageSize
	)
	$method = "claim_show"
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq "Name") {
		$params = @{
			name = $Name
		}
		if ($Nout) {
			$params.Add("nout", $Nout)
		}
	}
	if ($set -eq "Txid") {
		$params = @{
			txid = $Txid
		}
	}
	if ($set -eq "ClaimId") {
		$params = @{
			claim_id = $ClaimId
		}
	}
	if ($set -eq "Mine") {
		$method = "claim_list_mine"
		Get-LbryJsonContent -Method $method
		Return
	}
	if ($set -eq "Channel") {
		$method = "claim_list_by_channel"
		$params = @{
			uri = $Uri
		}
		if ($PageSize) {
			$params.Add("page_size", $PageSize)
		}
		if ($Page) {
			$params.Add("page", $Page)
		}
	}
	$result = Get-LbryJsonContent -Method $method -Params $params
	
	if ($set -eq "Channel") {
		$result.$Uri.claims_in_channel
	} else {
		$result.claim
	}
	
}
function New-LbryClaim() {
	param (
		[Parameter(Mandatory = $true)]
		[String]$Name,
		[Parameter(Mandatory = $true)]
		[float]$Bid = "1",
		[Parameter(Mandatory = $false)]
		[HashTable[]]$Metadata,
		[Parameter(Mandatory = $false)]
		[String]$FilePath,
		[Parameter(Mandatory = $false)]
		[HashTable]$fee,
		[Parameter(Mandatory = $true)]
		[String]$Title,
		[Parameter(Mandatory = $true)]
		[String]$Description,
		[Parameter(Mandatory = $true)]
		[String]$Author,
		[Parameter(Mandatory = $true)]
		[String]$Language = "en",
		[Parameter(Mandatory = $true)]
		[String]$License = "Public Domain",
		[Parameter(Mandatory = $false)]
		[String]$LicenseUrl,
		[Parameter(Mandatory = $false)]
		[String]$Thumbnail,
		[Parameter(Mandatory = $false)]
		[String]$Preview,
		[Parameter(Mandatory = $true)]
		[Boolean]$Nsfw = $true,
		[Parameter(Mandatory = $false)]
		[HashTable]$Sources,
		[Parameter(Mandatory = $false)]
		[String]$ChannelName
	)
	$method = "publish"
	$params = @{
		name	    = $Name
		bid		    = $Bid
		title	    = $Title
		description = $Description
		author	    = $Author
		language    = $Language
		license	    = $License
		nsfw	    = $Nsfw
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
	if ($Sources) {
		$params.Add("sources", $Sources)
	}
	if ($ChannelName) {
		$params.Add("channel_name", $ChannelName)
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Remove-LbryClaim() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$ClaimId
	)
	$method = "claim_abandon"
	$params = @{
		claim_id = $ClaimId
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryDaemon() {
	$method = "settings_get"
	Get-LbryJsonContent -Method $method
}
function Get-LbryDaemonStatus() {
	param (
		[Parameter(Position = 0, Mandatory = $false)]
		[Switch]$SessionStatus
	)
	$method = "status"
	if ($SessionStatus) {
		$params = @{
			session_status = $SessionStatus
		}
		Get-LbryJsonContent -Method $method -Params $params
		Return
	}
	Get-LbryJsonContent -Method $method
}

function Set-LbryDaemon() {
	param (
		[Parameter(Mandatory = $false)]
		[Boolean]$RunOnStartup,
		[Parameter(Mandatory = $false)]
		[Float]$DataRate,
		[Parameter(Mandatory = $false)]
		[Float]$MaxKeyFee,
		[Parameter(Mandatory = $false)]
		[String]$DownloadDirectory,
		[Parameter(Mandatory = $false)]
		[Float]$MaxUpload,
		[Parameter(Mandatory = $false)]
		[Float]$MaxDownload,
		[Parameter(Mandatory = $false)]
		[Int]$DownloadTimeout,
		[Parameter(Mandatory = $false)]
		[Float]$SearchTimeout,
		[Parameter(Mandatory = $false)]
		[Int]$CacheTime
	)
	$method = "settings_set"
	$params = @{}
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
function Stop-LbryDaemon() {
	$method = "daemon_stop"
	Get-LbryJsonContent -Method $method
}
function Get-LbryFile() {
	param (
		[Parameter(Position = 0, Mandatory = $true, ParameterSetName = "Name")]
		[String]$Name,
		[Parameter(Mandatory = $true, ParameterSetName = "SdHash")]
		[String]$SdHash,
		[Parameter(Mandatory = $true, ParameterSetName = "FileName")]
		[String]$FileName,
		[Parameter(Mandatory = $true, ParameterSetName = "StreamHash")]
		[String]$StreamHash,
		[Parameter(Mandatory = $true, ParameterSetName = "ClaimId")]
		[String]$ClaimId,
		[Parameter(Mandatory = $true, ParameterSetName = "Outpoint")]
		[String]$OutPoint,
		[Parameter(Mandatory = $true, ParameterSetName = "RowId")]
		[Int]$RowId,
		[Parameter(Mandatory = $false, ParameterSetName = "Name")]
		[Parameter(Mandatory = $false, ParameterSetName = "SdHash")]
		[Parameter(Mandatory = $false, ParameterSetName = "FileName")]
		[Parameter(Mandatory = $false, ParameterSetName = "StreamHash")]
		[Parameter(Mandatory = $false, ParameterSetName = "ClaimId")]
		[Parameter(Mandatory = $false, ParameterSetName = "Outpoint")]
		[Parameter(Mandatory = $false, ParameterSetName = "RowId")]
		[Boolean]$FullStatus
	)
	$method = "file_list"
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq "Name") {
		$params = @{
			name = $Name
		}
	}
	if ($set -eq "SdHash") {
		$params = @{
			sd_hash = $SdHash
		}
	}
	if ($set -eq "FileName") {
		$params = @{
			file_name = $FileName
		}
	}
	if ($set -eq "StreamHash") {
		$params = @{
			stream_hash = $StreamHash
		}
	}
	if ($set -eq "ClaimId") {
		$params = @{
			claim_id = $ClaimId
		}
	}
	if ($set -eq "Outpoint") {
		$params = @{
			outpoint = $Outpoint
		}
	}
	if ($set -eq "RowId") {
		$params = @{
			rowid = $RowId
		}
	}
	if ($FullStatus) {
		$params.Add("full_status", $FullStatus)
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Remove-LbryFile() {
	param (
		[Parameter(Position = 0, Mandatory = $true, ParameterSetName = "Name")]
		[String]$Name,
		[Parameter(Mandatory = $true, ParameterSetName = "SdHash")]
		[String]$SdHash,
		[Parameter(Mandatory = $true, ParameterSetName = "FileName")]
		[String]$FileName,
		[Parameter(Mandatory = $true, ParameterSetName = "StreamHash")]
		[String]$StreamHash,
		[Parameter(Mandatory = $true, ParameterSetName = "ClaimId")]
		[String]$ClaimId,
		[Parameter(Mandatory = $true, ParameterSetName = "Outpoint")]
		[String]$OutPoint,
		[Parameter(Mandatory = $true, ParameterSetName = "RowId")]
		[Int]$RowId,
		[Parameter(Mandatory = $false, ParameterSetName = "Name")]
		[Parameter(Mandatory = $false, ParameterSetName = "SdHash")]
		[Parameter(Mandatory = $false, ParameterSetName = "FileName")]
		[Parameter(Mandatory = $false, ParameterSetName = "StreamHash")]
		[Parameter(Mandatory = $false, ParameterSetName = "ClaimId")]
		[Parameter(Mandatory = $false, ParameterSetName = "Outpoint")]
		[Parameter(Mandatory = $false, ParameterSetName = "RowId")]
		[Boolean]$DeleteTargetFile
	)
	$method = "file_delete"
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq "Name") {
		$params = @{
			name = $Name
		}
	}
	if ($set -eq "SdHash") {
		$params = @{
			sd_hash = $SdHash
		}
	}
	if ($set -eq "FileName") {
		$params = @{
			file_name = $FileName
		}
	}
	if ($set -eq "StreamHash") {
		$params = @{
			stream_hash = $StreamHash
		}
	}
	if ($set -eq "ClaimId") {
		$params = @{
			claim_id = $ClaimId
		}
	}
	if ($set -eq "Outpoint") {
		$params = @{
			outpoint = $Outpoint
		}
	}
	if ($set -eq "RowId") {
		$params = @{
			rowid = $RowId
		}
	}
	if ($DeleteTargetFile) {
		$params.Add("delete_target_file", $DeleteTargetFile)
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Start-LbryFileDownload() {
	param (
		[Parameter(Position = 0, Mandatory = $true, ParameterSetName = "Name")]
		[String]$Name,
		[Parameter(Mandatory = $true, ParameterSetName = "SdHash")]
		[String]$SdHash,
		[Parameter(Mandatory = $true, ParameterSetName = "FileName")]
		[String]$FileName
	)
	$method = "file_set_status"
	$set = $PSCmdlet.ParameterSetName
	$params = @{
		status = "start"
	}
	if ($set -eq "Name") {
		$params.Add("name", $Name)
	}
	if ($set -eq "SdHash") {
		$params.Add("sd_hash", $SdHash)
	}
	if ($set -eq "FileName") {
		$params.Add("file_name", $FileName)
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Stop-LbryFileDownload() {
	param (
		[Parameter(Position = 0, Mandatory = $true, ParameterSetName = "Name")]
		[String]$Name,
		[Parameter(Mandatory = $true, ParameterSetName = "SdHash")]
		[String]$SdHash,
		[Parameter(Mandatory = $true, ParameterSetName = "FileName")]
		[String]$FileName
	)
	$method = "file_set_status"
	$set = $PSCmdlet.ParameterSetName
	$params = @{
		status = "stop"
	}
	if ($set -eq "Name") {
		$params.Add("name", $Name)
	}
	if ($set -eq "SdHash") {
		$params.Add("sd_hash", $SdHash)
	}
	if ($set -eq "FileName") {
		$params.Add("file_name", $FileName)
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryJsonContent() {
	param (
		[Parameter(Mandatory = $true)]
		[String]$Method,
		[Parameter(Mandatory = $false)]
		[Hashtable]$Params
	)
	$uri = "http://localhost:5279/lbryapi"
	if (($Params -eq "") -or ($Params -eq $null)) {
		$data = ConvertTo-Json @{
			method = $method
		}
	} else {
		$data = ConvertTo-Json @{
			method = $method; params = $params
		}
	}
	#Write-Host $data
	$output = Invoke-WebRequest -Uri $uri -Method Post -Body $data
	$content = ConvertFrom-Json $output.Content
	$content.result
}
function Get-LbryStream() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Uri,
		[Parameter(Mandatory = $false)]
		[String]$FileName,
		[Parameter(Mandatory = $false)]
		[Int]$Timeout,
		[Parameter(Mandatory = $false)]
		[String]$DownloadDirectory,
		[Parameter(Mandatory = $false)]
		[Switch]$Show
	)
	$method = "get"
	$params = @{
		uri  = $Uri
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
	if ($available -eq "0.0" -or [String]::IsNullOrWhiteSpace($Available)) {
		Write-Error "Stream is not available"
		Return
	}
	$cost = Get-LbryStreamCostEstimate $Uri
	if ($cost -ne "0.0") { 
		$title = "Payment Required"
		$message = "Confirm Payment: `"$cost`" LBC?"
		$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
						  "Pay and download stream."
		$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
						 "Refuse payment and exit."
		$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
		$pay = $host.ui.PromptForChoice($title, $message, $options, 0)
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
function Get-LbryStreamAvailability() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Uri,
		[Parameter(Mandatory = $false)]
		[Int]$SdTimeout,
		[Parameter(Mandatory = $false)]
		[Int]$PeerTimeout
	)
	$method = "get_availability"
	$params = @{
		uri = $Uri
	}
	if ($SdTimeout) {
		$params.Add("sd_timeout", $SdTimeout)
	}
	if ($PeerTimeout) {
		$params.Add("peer_timeout", $PeerTimeout)
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Sync-LbryStream() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$SdHash
	)
	$params = @{
		sd_hash = $SdHash
	}
	$method = "reflect"
	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryStreamCostEstimate() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Uri,
		[Parameter(Mandatory = $false)]
		[Int]$Size
	)
	$method = "stream_cost_estimate"
	$params = @{
		uri = $Uri
	}
	if ($Size) {
		$params.Add("size", $Size)
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Resolve-LbryStream() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Name
	)
	$params = @{
		name = $Name
	}
	$method = "resolve_name"
	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryTransaction() {
	param (
		[Parameter(Mandatory = $true, ParameterSetName = "Txid")]
		[String]$Txid,
		[Parameter(Mandatory = $true, ParameterSetName = "Wallet")]
		[Switch]$Wallet
	)
	if ($Wallet) {
		$method = "transaction_list"
		Get-LbryJsonContent -Method $method
		Return
	} else {
		$method = "transaction_show"
		$params = @{
			txid = $Txid
		}	
	Get-LbryJsonContent -Method $method -Params $params
	}
}
function Resolve-LbryUri() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Uri
	)
	$params = @{
		uri = $Uri
	}
	$method = "resolve"
	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryVersion() {
	$method = "version"
	Get-LbryJsonContent -Method $method
}
function Get-LbryWalletAddressList() {
	$method = "wallet_list"
	Get-LbryJsonContent -Method $method
}
function Get-LbryWalletAddressUnused() {
	$method = "wallet_unused_address"
	Get-LbryJsonContent -Method $method
}
function New-LbryWalletAddress() {
	$method = "wallet_new_address"
	Get-LbryJsonContent -Method $method
}
function Get-LbryWalletBalance() {
	$method = "wallet_balance"
	Get-LbryJsonContent -Method $method
}
function Send-LbryWalletCredits() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Address,
		[Parameter(Position = 1, Mandatory = $true)]
		[Float]$Amount
	)
	$method = "send_amount_to_address"
	$params = @{
		amount = $Amount
	}
	$params.Add("address", $Address)
	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryWalletPublicKey() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Address
	)
	$method = "wallet_public_key"
	$params = @{
		address = $Address
	}
	Get-LbryJsonContent -Method $method -Params $params
}
function Get-LbryWalletTransactionList() {
	$method = "transaction_list"
	Get-LbryJsonContent -Method $method
}
function Test-LbryWalletAddressOwnership() {
	param (
		[Parameter(Position = 0, Mandatory = $true)]
		[String]$Address
	)
	$method = "wallet_is_address_mine"
	$params = @{
		address = $Address
	}
	Get-LbryJsonContent -Method $method -Params $params
}