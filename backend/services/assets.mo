// This is a generated Motoko binding.
// Please use `import service "ic:canister_id"` instead to call canisters on the IC if possible.

module {
  public type AssetCanisterArgs = { #Upgrade : UpgradeArgs; #Init : InitArgs };
  public type BatchId = Nat;
  public type BatchOperationKind = {
    #SetAssetProperties : SetAssetPropertiesArguments;
    #CreateAsset : CreateAssetArguments;
    #UnsetAssetContent : UnsetAssetContentArguments;
    #DeleteAsset : DeleteAssetArguments;
    #SetAssetContent : SetAssetContentArguments;
    #Clear : ClearArguments;
  };
  public type ChunkId = Nat;
  public type ClearArguments = {};
  public type CommitBatchArguments = {
    batch_id : BatchId;
    operations : [BatchOperationKind];
  };
  public type CommitProposedBatchArguments = {
    batch_id : BatchId;
    evidence : [Nat8];
  };
  public type ComputeEvidenceArguments = {
    batch_id : BatchId;
    max_iterations : ?Nat16;
  };
  public type ConfigurationResponse = {
    max_batches : ?Nat64;
    max_bytes : ?Nat64;
    max_chunks : ?Nat64;
  };
  public type ConfigureArguments = {
    max_batches : ??Nat64;
    max_bytes : ??Nat64;
    max_chunks : ??Nat64;
  };
  public type CreateAssetArguments = {
    key : Key;
    content_type : Text;
    headers : ?[HeaderField];
    allow_raw_access : ?Bool;
    max_age : ?Nat64;
    enable_aliasing : ?Bool;
  };
  public type DeleteAssetArguments = { key : Key };
  public type DeleteBatchArguments = { batch_id : BatchId };
  public type GrantPermission = {
    permission : Permission;
    to_principal : Principal;
  };
  public type HeaderField = (Text, Text);
  public type HttpRequest = {
    url : Text;
    method : Text;
    body : [Nat8];
    headers : [HeaderField];
    certificate_version : ?Nat16;
  };
  public type HttpResponse = {
    body : [Nat8];
    headers : [HeaderField];
    streaming_strategy : ?StreamingStrategy;
    status_code : Nat16;
  };
  public type InitArgs = {};
  public type Key = Text;
  public type ListPermitted = { permission : Permission };
  public type Permission = { #Prepare; #ManagePermissions; #Commit };
  public type RevokePermission = {
    permission : Permission;
    of_principal : Principal;
  };
  public type SetAssetContentArguments = {
    key : Key;
    sha256 : ?[Nat8];
    chunk_ids : [ChunkId];
    content_encoding : Text;
  };
  public type SetAssetPropertiesArguments = {
    key : Key;
    headers : ??[HeaderField];
    is_aliased : ??Bool;
    allow_raw_access : ??Bool;
    max_age : ??Nat64;
  };
  public type SetPermissions = {
    prepare : [Principal];
    commit : [Principal];
    manage_permissions : [Principal];
  };
  public type StreamingCallbackHttpResponse = {
    token : ?StreamingCallbackToken;
    body : [Nat8];
  };
  public type StreamingCallbackToken = {
    key : Key;
    sha256 : ?[Nat8];
    index : Nat;
    content_encoding : Text;
  };
  public type StreamingStrategy = {
    #Callback : {
      token : StreamingCallbackToken;
      callback : shared query StreamingCallbackToken -> async ?StreamingCallbackHttpResponse;
    };
  };
  public type Time = Int;
  public type UnsetAssetContentArguments = {
    key : Key;
    content_encoding : Text;
  };
  public type UpgradeArgs = { set_permissions : ?SetPermissions };
  public type ValidationResult = { #Ok : Text; #Err : Text };
  public type Self = ?AssetCanisterArgs -> async actor {
    api_version : shared query () -> async Nat16;
    authorize : shared Principal -> async ();
    certified_tree : shared query {} -> async {
        certificate : [Nat8];
        tree : [Nat8];
      };
    clear : shared ClearArguments -> async ();
    commit_batch : shared CommitBatchArguments -> async ();
    commit_proposed_batch : shared CommitProposedBatchArguments -> async ();
    compute_evidence : shared ComputeEvidenceArguments -> async ?[Nat8];
    configure : shared ConfigureArguments -> async ();
    create_asset : shared CreateAssetArguments -> async ();
    create_batch : shared {} -> async { batch_id : BatchId };
    create_chunk : shared { content : [Nat8]; batch_id : BatchId } -> async {
        chunk_id : ChunkId;
      };
    deauthorize : shared Principal -> async ();
    delete_asset : shared DeleteAssetArguments -> async ();
    delete_batch : shared DeleteBatchArguments -> async ();
    get : shared query { key : Key; accept_encodings : [Text] } -> async {
        content : [Nat8];
        sha256 : ?[Nat8];
        content_type : Text;
        content_encoding : Text;
        total_length : Nat;
      };
    get_asset_properties : shared query Key -> async {
        headers : ?[HeaderField];
        is_aliased : ?Bool;
        allow_raw_access : ?Bool;
        max_age : ?Nat64;
      };
    get_chunk : shared query {
        key : Key;
        sha256 : ?[Nat8];
        index : Nat;
        content_encoding : Text;
      } -> async { content : [Nat8] };
    get_configuration : shared () -> async ConfigurationResponse;
    grant_permission : shared GrantPermission -> async ();
    http_request : shared query HttpRequest -> async HttpResponse;
    http_request_streaming_callback : shared query StreamingCallbackToken -> async ?StreamingCallbackHttpResponse;
    list : shared query {} -> async [
        {
          key : Key;
          encodings : [
            {
              modified : Time;
              sha256 : ?[Nat8];
              length : Nat;
              content_encoding : Text;
            }
          ];
          content_type : Text;
        }
      ];
    list_authorized : shared () -> async [Principal];
    list_permitted : shared ListPermitted -> async [Principal];
    propose_commit_batch : shared CommitBatchArguments -> async ();
    revoke_permission : shared RevokePermission -> async ();
    set_asset_content : shared SetAssetContentArguments -> async ();
    set_asset_properties : shared SetAssetPropertiesArguments -> async ();
    store : shared {
        key : Key;
        content : [Nat8];
        sha256 : ?[Nat8];
        content_type : Text;
        content_encoding : Text;
      } -> async ();
    take_ownership : shared () -> async ();
    unset_asset_content : shared UnsetAssetContentArguments -> async ();
    validate_commit_proposed_batch : shared CommitProposedBatchArguments -> async ValidationResult;
    validate_configure : shared ConfigureArguments -> async ValidationResult;
    validate_grant_permission : shared GrantPermission -> async ValidationResult;
    validate_revoke_permission : shared RevokePermission -> async ValidationResult;
    validate_take_ownership : shared () -> async ValidationResult;
  }
}
