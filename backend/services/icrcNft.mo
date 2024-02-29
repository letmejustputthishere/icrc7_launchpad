// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
  public type Account = { owner : Principal; subaccount : ?Subaccount };
  public type Account__1 = { owner : Principal; subaccount : ?Subaccount };
  public type Account__2 = { owner : Principal; subaccount : ?Subaccount };
  public type Account__3 = { owner : Principal; subaccount : ?Subaccount };
  public type ApprovalCollectionResponse = {
    #Ok : Nat;
    #Err : ApproveCollectionError;
  };
  public type ApprovalInfo = {
    memo : ?[Nat8];
    from_subaccount : ?[Nat8];
    created_at_time : ?Nat64;
    expires_at : ?Nat64;
    spender : Account__2;
  };
  public type ApprovalInfo__1 = {
    memo : ?[Nat8];
    from_subaccount : ?[Nat8];
    created_at_time : ?Nat64;
    expires_at : ?Nat64;
    spender : Account__2;
  };
  public type ApprovalResponse = {
    #Ok : [ApprovalResponseItem];
    #Err : ApproveTokensBatchError;
  };
  public type ApprovalResponseItem = {
    token_id : Nat;
    approval_result : ApprovalResult;
  };
  public type ApprovalResult = { #Ok : Nat; #Err : ApproveTokensError };
  public type ApproveCollectionError = {
    #GenericError : { message : Text; error_code : Nat };
    #Duplicate : { duplicate_of : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
  };
  public type ApproveTokensBatchError = {
    #GenericError : { message : Text; error_code : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
  };
  public type ApproveTokensError = {
    #GenericError : { message : Text; error_code : Nat };
    #Duplicate : { duplicate_of : Nat };
    #NonExistingTokenId;
    #Unauthorized;
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
  };
  public type ArchivedTransactionResponse = {
    args : [TransactionRange__1];
    callback : GetTransactionsFn;
  };
  public type BurnNFTBatchError = {
    #GenericError : { message : Text; error_code : Nat };
    #Unauthorized;
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
  };
  public type BurnNFTBatchResponse = {
    #Ok : [BurnNFTItemResponse];
    #Err : BurnNFTBatchError;
  };
  public type BurnNFTError = {
    #GenericError : { message : Text; error_code : Nat };
    #NonExistingTokenId;
    #InvalidBurn;
  };
  public type BurnNFTItemResponse = { result : BurnNFTResult; token_id : Nat };
  public type BurnNFTResult = { #Ok : Nat; #Err : BurnNFTError };
  public type CollectionApproval = {
    memo : ?[Nat8];
    from_subaccount : ?[Nat8];
    created_at_time : ?Nat64;
    expires_at : ?Nat64;
    spender : Account__2;
  };
  public type DataCertificate = { certificate : [Nat8]; hash_tree : [Nat8] };
  public type GetArchivesArgs = { from : ?Principal };
  public type GetArchivesResult = [GetArchivesResultItem];
  public type GetArchivesResultItem = {
    end : Nat;
    canister_id : Principal;
    start : Nat;
  };
  public type GetTransactionsFn = shared query [
      TransactionRange__1
    ] -> async GetTransactionsResult__1;
  public type GetTransactionsResult = {
    log_length : Nat;
    blocks : [{ id : Nat; block : Value__2 }];
    archived_blocks : [ArchivedTransactionResponse];
  };
  public type GetTransactionsResult__1 = {
    log_length : Nat;
    blocks : [{ id : Nat; block : Value__2 }];
    archived_blocks : [ArchivedTransactionResponse];
  };
  public type IndexType = { #Stable; #StableTyped; #Managed };
  public type InitArgs = {
    icrc3_args : InitArgs__2;
    icrc30_args : InitArgs__1;
    icrc7_args : InitArgs__4;
  };
  public type InitArgs__1 = ?{
    deployer : Principal;
    max_approvals : ?Nat;
    max_approvals_per_token_or_collection : ?Nat;
    settle_to_approvals : ?Nat;
    max_revoke_approvals : ?Nat;
    collection_approval_requires_token : ?Bool;
  };
  public type InitArgs__2 = ?InitArgs__3;
  public type InitArgs__3 = {
    maxRecordsToArchive : Nat;
    archiveIndexType : IndexType;
    maxArchivePages : Nat;
    settleToRecords : Nat;
    archiveCycles : Nat;
    maxActiveRecords : Nat;
    maxRecordsInArchiveInstance : Nat;
    archiveControllers : ??[Principal];
  };
  public type InitArgs__4 = ?{
    deployer : Principal;
    allow_transfers : ?Bool;
    supply_cap : ?Nat;
    burn_account : ?Account;
    default_take_value : ?Nat;
    logo : ?Text;
    permitted_drift : ?Nat;
    name : ?Text;
    description : ?Text;
    max_take_value : ?Nat;
    max_update_batch_size : ?Nat;
    max_query_batch_size : ?Nat;
    max_memo_size : ?Nat;
    supported_standards : ?SupportedStandards;
    symbol : ?Text;
  };
  public type NFTCanister = actor {
    burn : shared Nat -> async BurnNFTBatchResponse;
    get_tip : shared query () -> async Tip;
    icrc30_approve_collection : shared ApprovalInfo__1 -> async ApprovalCollectionResponse;
    icrc30_approve_tokens : shared (
        [Nat],
        ApprovalInfo__1,
      ) -> async ApprovalResponse;
    icrc30_get_collection_approvals : shared query (
        Account__3,
        ?CollectionApproval,
        ?Nat,
      ) -> async [CollectionApproval];
    icrc30_get_token_approvals : shared query (
        [Nat],
        ?TokenApproval,
        ?Nat,
      ) -> async [TokenApproval];
    icrc30_is_approved : shared query (Account__3, ?[Nat8], Nat) -> async Bool;
    icrc30_max_approvals_per_token_or_collection : shared query () -> async ?Nat;
    icrc30_max_revoke_approvals : shared query () -> async ?Nat;
    icrc30_metadata : shared query () -> async [(Text, Value__3)];
    icrc30_revoke_collection_approvals : shared RevokeCollectionArgs -> async RevokeCollectionResponse;
    icrc30_revoke_token_approvals : shared RevokeTokensArgs -> async RevokeTokensResponse;
    icrc30_transfer_from : shared TransferFromArgs -> async TransferFromResponse;
    icrc3_get_archives : shared query GetArchivesArgs -> async GetArchivesResult;
    icrc3_get_blocks : shared query [
        TransactionRange
      ] -> async GetTransactionsResult;
    icrc3_get_tip_certificate : shared query () -> async ?DataCertificate;
    icrc7_balance_of : shared query Account__1 -> async Nat;
    icrc7_collection_metadata : shared query () -> async [(Text, Value__1)];
    icrc7_default_take_value : shared query () -> async ?Nat;
    icrc7_description : shared query () -> async ?Text;
    icrc7_logo : shared query () -> async ?Text;
    icrc7_max_memo_size : shared query () -> async ?Nat;
    icrc7_max_query_batch_size : shared query () -> async ?Nat;
    icrc7_max_take_value : shared query () -> async ?Nat;
    icrc7_max_update_batch_size : shared query () -> async ?Nat;
    icrc7_name : shared query () -> async Text;
    icrc7_owner_of : shared query [Nat] -> async OwnerOfResponses;
    icrc7_supply_cap : shared query () -> async ?Nat;
    icrc7_supported_standards : shared query () -> async SupportedStandards__1;
    icrc7_symbol : shared query () -> async Text;
    icrc7_token_metadata : shared query [Nat] -> async [
        { token_id : Nat; metadata : NFTMap }
      ];
    icrc7_tokens : shared query (?Nat, ?Nat) -> async [Nat];
    icrc7_tokens_of : shared query (Account__1, ?Nat, ?Nat) -> async [Nat];
    icrc7_total_supply : shared query () -> async Nat;
    icrc7_transfer : shared TransferArgs -> async TransferResponse;
    mint : shared Account__1 -> async SetNFTBatchResponse;
  };
  public type NFTMap = [(Text, Value)];
  public type OwnerOfResponse = { token_id : Nat; account : ?Account };
  public type OwnerOfResponses = [OwnerOfResponse];
  public type RevokeCollectionArgs = {
    memo : ?[Nat8];
    from_subaccount : ?[Nat8];
    created_at_time : ?Nat64;
    spender : ?Account__2;
  };
  public type RevokeCollectionBatchError = {
    #GenericError : { message : Text; error_code : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
  };
  public type RevokeCollectionResponse = {
    #Ok : [RevokeCollectionResponseItem];
    #Err : RevokeCollectionBatchError;
  };
  public type RevokeCollectionResponseItem = {
    spender : ?Account__2;
    revoke_result : RevokeTokensResult;
  };
  public type RevokeTokensArgs = {
    memo : ?[Nat8];
    from_subaccount : ?[Nat8];
    token_ids : [Nat];
    created_at_time : ?Nat64;
    spender : ?Account__2;
  };
  public type RevokeTokensBatchError = {
    #GenericError : { message : Text; error_code : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
  };
  public type RevokeTokensError = {
    #GenericError : { message : Text; error_code : Nat };
    #Duplicate : { duplicate_of : Nat };
    #NonExistingTokenId;
    #Unauthorized;
    #ApprovalDoesNotExist;
  };
  public type RevokeTokensResponse = {
    #Ok : [RevokeTokensResponseItem];
    #Err : RevokeTokensBatchError;
  };
  public type RevokeTokensResponseItem = {
    token_id : Nat;
    spender : ?Account__2;
    revoke_result : RevokeTokensResult;
  };
  public type RevokeTokensResult = { #Ok : Nat; #Err : RevokeTokensError };
  public type SetNFTBatchError = {
    #GenericError : { message : Text; error_code : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #TooOld;
  };
  public type SetNFTBatchResponse = {
    #Ok : [SetNFTItemResponse];
    #Err : SetNFTBatchError;
  };
  public type SetNFTError = {
    #GenericError : { message : Text; error_code : Nat };
    #TokenExists;
    #NonExistingTokenId;
  };
  public type SetNFTItemResponse = { result : SetNFTResult; token_id : Nat };
  public type SetNFTResult = {
    #Ok : Nat;
    #Err : SetNFTError;
    #GenericError : { message : Text; error_code : Nat };
  };
  public type Subaccount = [Nat8];
  public type SupportedStandards = [{ url : Text; name : Text }];
  public type SupportedStandards__1 = [{ url : Text; name : Text }];
  public type Tip = {
    last_block_index : [Nat8];
    hash_tree : [Nat8];
    last_block_hash : [Nat8];
  };
  public type TokenApproval = { token_id : Nat; approval_info : ApprovalInfo };
  public type TransactionRange = { start : Nat; length : Nat };
  public type TransactionRange__1 = { start : Nat; length : Nat };
  public type TransferArgs = {
    to : Account;
    memo : ?[Nat8];
    subaccount : ?[Nat8];
    token_ids : [Nat];
    created_at_time : ?Nat64;
  };
  public type TransferBatchError = {
    #GenericError : { message : Text; error_code : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #InvalidRecipient;
    #TooOld;
  };
  public type TransferError = {
    #GenericError : { message : Text; error_code : Nat };
    #Duplicate : { duplicate_of : Nat };
    #NonExistingTokenId;
    #Unauthorized;
  };
  public type TransferFromArgs = {
    to : Account__2;
    spender_subaccount : ?[Nat8];
    from : Account__2;
    memo : ?[Nat8];
    token_ids : [Nat];
    created_at_time : ?Nat64;
  };
  public type TransferFromBatchError = {
    #GenericError : { message : Text; error_code : Nat };
    #CreatedInFuture : { ledger_time : Nat64 };
    #InvalidRecipient;
    #TooOld;
  };
  public type TransferFromError = {
    #GenericError : { message : Text; error_code : Nat };
    #Duplicate : { duplicate_of : Nat };
    #NonExistingTokenId;
    #Unauthorized;
  };
  public type TransferFromResponse = {
    #Ok : [TransferFromResponseItem];
    #Err : TransferFromBatchError;
  };
  public type TransferFromResponseItem = {
    token_id : Nat;
    transfer_result : { #Ok : Nat; #Err : TransferFromError };
  };
  public type TransferResponse = {
    #Ok : [TransferResponseItem];
    #Err : TransferBatchError;
  };
  public type TransferResponseItem = {
    token_id : Nat;
    transfer_result : { #Ok : Nat; #Err : TransferError };
  };
  public type Value = {
    #Int : Int;
    #Map : [(Text, Value)];
    #Nat : Nat;
    #Blob : [Nat8];
    #Text : Text;
    #Array : [Value];
  };
  public type Value__1 = {
    #Int : Int;
    #Map : [(Text, Value)];
    #Nat : Nat;
    #Blob : [Nat8];
    #Text : Text;
    #Array : [Value];
  };
  public type Value__2 = {
    #Int : Int;
    #Map : [(Text, Value__2)];
    #Nat : Nat;
    #Blob : [Nat8];
    #Text : Text;
    #Array : [Value__2];
  };
  public type Value__3 = {
    #Int : Int;
    #Map : [(Text, Value)];
    #Nat : Nat;
    #Blob : [Nat8];
    #Text : Text;
    #Array : [Value];
  };
  public type Self = InitArgs -> async NFTCanister
}
