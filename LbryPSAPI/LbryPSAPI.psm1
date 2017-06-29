function Get-JsonContent(){
	[CmdletBinding()]
	
	param (
	[Parameter(Mandatory = $true, Position = 0)]
	[String]$Method,
	[Parameter(Mandatory = $false, Position = 1)]
	[Hashtable]$Params
	)
	$uri = "http://localhost:5279/lbryapi"
	if(($Params -eq "") -or ($Params -eq $null)){
		$data = ConvertTo-Json @{method = $method}
	} else{
		$data = ConvertTo-Json @{method = $method;params = $params}
	}
	$data
	$output = Invoke-WebRequest -Uri $uri -Method Post -Body $data
	$content = ConvertFrom-Json $output.Content

$content.result	

}

function Sync-Blob(){
	[CmdletBinding()]

	param (
		[Parameter(Mandatory = $true, ParameterSetName = "AnnounceAll")]	
		[Switch]$AnnounceAll = $false,
		[Parameter(Mandatory = $true, ParameterSetName = "ReflectAll")]
		[Switch]$ReflectAll = $false
	)

	if ($AnnounceAll) {$method = "blob_announce_all"}
	if ($ReflectAll) {$method = "blob_reflect_all"}
	
	Get-JsonContent -Method $method
}

function Remove-Blob(){
	[CmdletBinding()]

	$method = "blob_delete"
	
	Get-JsonContent -Method $method
}

function Get-Blob(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true)]
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
	$params = @{blob_hash = $BlobHash}
	if ($Timeout -ne "") {$params.Add("timeout",$Timeout)}
	if ($Encoding -ne "") {$params.Add("encoding",$Encoding)}
	if ($PaymentRateManager -ne "") {$params.Add("payment_rate_manager",$PaymentRateManager)}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Get-BlobHash(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $false, ParameterSetName = 'All')]
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

	if ($All) {Get-JsonContent -method $method ; Return}
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq "Uri") {$params = @{uri = $Uri}}
	if ($set -eq "StreamHash") {$params = @{stream_hash = $StreamHash}}
	if ($set -eq "SdHash") {$params = @{sd_hash = $SdHash}}
	if ($Needed -ne "") {$params.Add("needed",$Needed)}
	if ($Finished -ne "") {$params.Add("finished",$Finished)}
	if ($PageSize -ne "") {$params.Add("page_size",$PageSize)}
	if ($Page -ne "") {$params.Add("page",$Page)}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Show-Block(){
	[CmdletBinding()]
	
	param (
	[Parameter(Mandatory = $true)]
	[String]$Blockhash
	)
	$params = @{blockhash = $Blockhash}
	$method = "block_show"
	
	Get-JsonContent -Method $method
	
}

function Get-ChannelPublished(){
	[CmdletBinding()]

	$method = "channel_list_mine"
	
	Get-JsonContent -Method $method
	
}

function Publish-Channel(){
	[CmdletBinding()]
	
	param (
	[Parameter(Mandatory = $true,Position = 0)]
	[String]$ChannelName,
	[Parameter(Mandatory = $true,Position = 1)]
	[float]$Amount
	)
	$method = "channel_new"
	$params = @{channel_name = $ChannelName;
				amount = $Amount
	}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Unpublish-Channel(){
	[CmdletBinding()]
	
	param (
	[Parameter(Mandatory = $true,Position = 0)]
	[String]$ChannelName,
	[Parameter(Mandatory = $false,Position = 1)]
	[float]$Amount
	)
	$method = "claim_abandon"
	$params = @{channel_name = $ChannelName;
				amount = $Amount
	}
	
	Get-JsonContent -Method $method -Params $params
	
}

function New-Claim(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true)]
		[String]$Name,
		[Parameter(Mandatory = $false)]
		[float]$Bid,
		[Parameter(Mandatory = $false)]
		[HashTable[]]$Metadata,
		[Parameter(Mandatory = $false)]
		[String]$FilePath,
		[Parameter(Mandatory = $false)]
		[HashTable]$fee,
		[Parameter(Mandatory = $false)]
		[String]$Title,
		[Parameter(Mandatory = $false)]
		[String]$Description,
		[Parameter(Mandatory = $false)]
		[String]$Author,
		[Parameter(Mandatory = $false)]
		[String]$Language,
		[Parameter(Mandatory = $false)]
		[String]$License,
		[Parameter(Mandatory = $false)]
		[String]$LicenseUrl,
		[Parameter(Mandatory = $false)]
		[String]$Thumbnail,
		[Parameter(Mandatory = $false)]
		[String]$Preview,
		[Parameter(Mandatory = $false)]
		[Boolean]$Nsfw,
		[Parameter(Mandatory = $false)]
		[HashTable]$Sources,
		[Parameter(Mandatory = $false)]
		[String]$ChannelName
	)

	$method = "publish"
	$params = @{bid = $Bid}
	if ($Metadata -ne "") {$params.Add("metadata",$Metadata)}
	if ($FilePath -ne "") {$params.Add("file_path",$FilePath)}
	if ($Fee -ne "") {$params.Add("fee",$Fee)}
	if ($Title -ne "") {$params.Add("title",$Title)}
	if ($Description -ne "") {$params.Add("description",$Description)}
	if ($Author -ne "") {$params.Add("author",$Author)}
	if ($Language -ne "") {$params.Add("language",$Language)}
	if ($License -ne "") {$params.Add("license",$License)}
	if ($LicenseUrl -ne "") {$params.Add("license_url",$LicenseUrl)}
	if ($Thumbnail -ne "") {$params.Add("thumbnail",$Thumbnail)}
	if ($Preview -ne "") {$params.Add("preview",$Preview)}
	if ($Nsfw -ne "") {$params.Add("nsfw",$Nsfw)}
	if ($Sources -ne "") {$params.Add("sources",$Sources)}
	if ($ChannelName -ne "") {$params.Add("channel_name",$ChannelName)}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Add-ClaimSupport(){
	[CmdletBinding()]
	
	param (
	[Parameter(Mandatory = $true, ParameterSetName = "Name")]
	[String]$Name,
	[Parameter(Mandatory = $true, ParameterSetName = "ClaimId")]
	[String]$ClaimId,
	[Parameter(Mandatory = $true, ParameterSetName = "Name")]
	[Parameter(Mandatory = $true, ParameterSetName = "ClaimId")]
	[float]$Amount
	)
	$method = "claim_list"
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq "Name") {$params = @{name = $Name}}
	if ($set -eq "ClaimId") {$params = @{claim_id = $ClaimId}}
	$params.Add("amount",$Amount)

	Get-JsonContent -Method $method -Params $params
	
}

function Get-Claim(){
	[CmdletBinding()]
	
	param (
	[Parameter(Mandatory = $true, ParameterSetName = "Mine")]
	[Switch]$Mine = $false,
	[Parameter(Mandatory = $true, ParameterSetName = "Name")]
	[String]$Name,
	[Parameter(Mandatory = $true, ParameterSetName = "Txid")]
	[String]$Txid,
	[Parameter(Mandatory = $true, ParameterSetName = "Nout")]
	[String]$Nout,
	[Parameter(Mandatory = $true, ParameterSetName = "ClaimId")]
	[String]$ClaimId	
	)
	
	$method = "claim_show"
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq "Mine") {
		$method = "claim_list_mine"
		Get-JsonContent -Method $method
		Return
	}
	if ($set -eq "Name") {$params = @{name = $Name}}
	if ($set -eq "Txid") {$params = @{tx_id = $Txid}}
	if ($set -eq "Nout") {$params = @{nout = $Nout}}
	if ($set -eq "ClaimId") {$params = @{claim_id = $ClaimId}}
	
	$result = Get-JsonContent -Method $method -Params $params
	$result.claim
}

function Stop-Daemon(){
	[CmdletBinding()]

	$method = "lbrynet-daemon"
	
	Get-JsonContent -Method $method
	
}

function Get-Descriptor(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true)]
		[String]$SdHash,
		[Parameter(Mandatory = $false)]
		[Int]$Timeout,
		[Parameter(Mandatory = $false)]
		[String]$PaymentRateManager
	)

	$method = "descriptor_get"
	$params = @{blob_hash = $BlobHash}
	if ($Timeout -ne "") {$params.Add("timeout",$Timeout)}
	if ($PaymentRateManager -ne "") {$params.Add("payment_rate_manager",$PaymentRateManager)}

	Get-JsonContent -Method $method -Params $params

}

function Remove-File(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true, ParameterSetName = "Name")]
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
	if ($set -eq "Name") {$params = @{name = $Name}}
	if ($set -eq "SdHash") {$params = @{sd_hash = $SdHash}}
	if ($set -eq "FileName") {$params = @{file_name = $FileName}}
	if ($set -eq "StreamHash") {$params = @{stream_hash = $StreamHash}}
	if ($set -eq "ClaimId") {$params = @{claim_id = $ClaimId}}
	if ($set -eq "Outpoint") {$params = @{outpoint = $Outpoint}}
	if ($set -eq "RowId") {$params = @{rowid = $RowId}}
	if ($DeleteTargetFile -ne "") {$params.Add("delete_target_file",$DeleteTargetFile)}

	Get-JsonContent -Method $method -Params $params

}

function Get-File(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true, ParameterSetName = "Name")]
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
		[Boolean]$full_status
	)
	$method = "file_list"
	$set = $PSCmdlet.ParameterSetName
	if ($set -eq "Name") {$params = @{name = $Name}}
	if ($set -eq "SdHash") {$params = @{sd_hash = $SdHash}}
	if ($set -eq "FileName") {$params = @{file_name = $FileName}}
	if ($set -eq "StreamHash") {$params = @{stream_hash = $StreamHash}}
	if ($set -eq "ClaimId") {$params = @{claim_id = $ClaimId}}
	if ($set -eq "Outpoint") {$params = @{outpoint = $Outpoint}}
	if ($set -eq "RowId") {$params = @{rowid = $RowId}}
	if ($FullStatus -ne "") {$params.Add("full_status",$FullStatus)}

	Get-JsonContent -Method $method -Params $params

}

function Set-FileStatus(){
	[CmdletBinding()]
	
	param (
	[Parameter(Mandatory = $true, ParameterSetName = "Name")]
	[String]$Name,
	[Parameter(Mandatory = $true, ParameterSetName = "SdHash")]
	[String]$SdHash,
	[Parameter(Mandatory = $true, ParameterSetName = "FileName")]
	[String]$FileName,
	[Parameter(Mandatory = $true, ParameterSetName = "Name")]
	[Parameter(Mandatory = $true, ParameterSetName = "SdHash")]
	[Parameter(Mandatory = $true, ParameterSetName = "FileName")]
	[Parameter(Mandatory = $true, ParameterSetName = "Status")]
	[String]$Status
	)
	$method = "file_set_status"
	$set = $PSCmdlet.ParameterSetName
	$params = @{status = $Status}
	if ($set -eq "Name") {$params.Add("name",$Name)}
	if ($set -eq "SdHash") {$params.Add("sd_hash",$SdHash)}
	if ($set -eq "FileName") {$params.Add("file_name",$FileName)}
	
	$result = Get-JsonContent -Method $method -Params $params
}

function Get-Stream(){
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)]
		[String]$Uri,
		[Parameter(Mandatory = $false)]
		[String]$FileName,
		[Parameter(Mandatory = $false)]
		[Int]$Timeout,
		[Parameter(Mandatory = $false)]
		[String]$DownloadDirectory
	)

	$method = "get"
	$params = @{uri = $Uri}
	if ($FileName -ne "") {$params.Add("file_name",$FileName)}
	if ($Timeout -ne "") {$params.Add("timeout",$Timeout)}
	if ($DownloadDirectory -ne "") {$params.Add("download_directory",$DownloadDirectory)}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Get-StreamAvailability(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true)]
		[String]$Uri,
		[Parameter(Mandatory = $false)]
		[Int]$SdTimeout,
		[Parameter(Mandatory = $false)]
		[Int]$PeerTimeout
	)

	$method = "get_availability"
	$params = @{uri = $Uri}
	if ($SdTimeout -ne "") {$params.Add("sd_timeout",$SdTimeout)}
	if ($PeerTimeout -ne "") {$params.Add("peer_timeout",$PeerTimeout)}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Get-BlobPeer(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true)]
		[String]$BlobHash,

		[Parameter(Mandatory = $false)]
		[Int]$Timeout
	)

	$method = "peer_list"
	$params = @{blob_hash = $BlobHash}
	if ($Timeout -ne "") {$params.Add("timeout",$Timeout)}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Sync-Stream(){
	[CmdletBinding()]

	param (
		[Parameter(Mandatory = $true)]
		[String]$SdHash
	)
	$params = @{sd_hash = $SdHash}
	$method = "reflect"
	
	Get-JsonContent -Method $method -Params $params
}

function New-BugReport(){
	[CmdletBinding()]

	param (
		[Parameter(Mandatory = $true)]
		[String]$SdHash
	)
	$params = @{sd_hash = $SdHash}
	$method = "report_bug"
	
	Get-JsonContent -Method $method -Params $params
}

function Resolve-Uri(){
	[CmdletBinding()]

	param (
		[Parameter(Mandatory = $true)]
		[String]$Uri
	)
	$params = @{uri = $Uri}
	$method = "resolve"
	
	Get-JsonContent -Method $method -Params $params
}

function Resolve-Name(){
	[CmdletBinding()]

	param (
		[Parameter(Mandatory = $true)]
		[String]$Name
	)
	$params = @{name = $Name}
	$method = "resolve_name"
	
	Get-JsonContent -Method $method -Params $params
}

function Send-AmountToAddress(){
	[CmdletBinding()]

	param (
		[Parameter(Mandatory = $true)]
		[Float]$Amount,
		[Parameter(Mandatory = $true)]
		[String]$Address
	)
	$method = "send_amount_to_address"
	$params = @{ammount = $Amount}
	$params.Add("address",$Address)
	
	Get-JsonContent -Method $method -Params $params
}

function Get-Daemon(){
	[CmdletBinding()]

	$method = "settings_get"
	
	Get-JsonContent -Method $method
}

function Set-Daemon(){
	[CmdletBinding()]

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
	if ($RunOnStartup -ne "") {$params.Add("run_on_startup",$RunOnStartup)}
	if ($DataRate -ne "") {$params.Add("data_rate",$DataRate)}
	if ($MaxKeyFee -ne "") {$params.Add("max_key_fee",$MaxKeyFee)}
	if ($DownloadDirectory -ne "") {$params.Add("download_directory",$DownloadDirectory)}
	if ($MaxUpload -ne "") {$params.Add("max_upload",$MaxUpload)}
	if ($MaxDownload -ne "") {$params.Add("max_download",$MaxDownload)}
	if ($DownloadTimeout -ne "") {$params.Add("download_timeout",$DownloadTimeout)}
	if ($SearchTimeout -ne "") {$params.Add("search_timeout",$SearchTimeout)}
	if ($CacheTime -ne "") {$params.Add("cache_time",$CacheTime)}
		
	Get-JsonContent -Method $method
}

function Get-DaemonStatus(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $false)]
		[Boolean]$SessionStatus = $false
	)

	$method = "status"
	$params = @{session_status = $SessionStatus}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Get-StreamCostEstimate(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true)]
		[String]$Name,
		[Parameter(Mandatory = $false)]
		[Int]$Size
	)

	$method = "stream_cost_estimate"
	$params = @{name = $Name}
	if ($Size -ne "") {$params.Add("size",$Size)}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Get-TransactionList(){
	[CmdletBinding()]
	
	$method = "transaction_list"
	
	Get-JsonContent -Method $method
	
}

function Show-Transaction(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $false)]
		[String]$Txid
	)

	if ($Txid -eq "") {
	
		$method = "transaction_list"
		
		Get-JsonContent -Method $method
	} else {
	
		$method = "transaction_show"
		$params = @{txid = $Txid}
		
		Get-JsonContent -Method $method -Params $params
	}
}

function Get-Version(){
	[CmdletBinding()]

	$method = "version"
	
	Get-JsonContent -Method $method
}

function Get-WalletBalance(){
	[CmdletBinding()]

	$method = "wallet_balance"
	
	Get-JsonContent -Method $method
}

function Test-WalletAddressOwnership(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true)]
		[String]$Address
	)

	$method = "wallet_is_address_mine"
	$params = @{address = $Address}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Get-WalletAddress(){
	[CmdletBinding()]

	$method = "wallet_list"
	
	Get-JsonContent -Method $method
}

function New-WalletAddress(){
	[CmdletBinding()]

	$method = "wallet_new_address"
	
	Get-JsonContent -Method $method
}

function Get-WalletPublicKey(){
	[CmdletBinding()]
	
	param (
		[Parameter(Mandatory = $true)]
		[String]$Address
	)

	$method = "wallet_public_key"
	$params = @{address = $Address}
	
	Get-JsonContent -Method $method -Params $params
	
}

function Get-WalletAddressUnused(){
	[CmdletBinding()]

	$method = "wallet_unused_address"
	
	Get-JsonContent -Method $method
}
