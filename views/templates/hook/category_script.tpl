
{addJsDef ELITRACK_CLIENT_ID=$ELITRACK_CLIENT_ID|escape:'html':'UTF-8'}
{addJsDef hash_enabled=$hash_enabled|escape:'html':'UTF-8'}
{addJsDef controller_name=$controller_name|escape:'html':'UTF-8'}

{literal}
<script type="text/javascript">
// category page

var pagename = '{/literal}{$controller_name}{literal}';
var elitrack_client_ids = '{/literal}{$ELITRACK_CLIENT_ID}{literal}';
var user_id = '{/literal}{$cookie->id_customer}{literal}';
var category_id = '{/literal}{$category->id}{literal}';
var hash_enabled = '{/literal}{$hash_enabled}{literal}';

(function() {
if(hash_enabled == 1) {
	if(user_id == "") {
		user_id == "";
	}
	else {
		user_id = $.md5(user_id);
	}
}
else {
	user_id = "";
}

var script = document.createElement("script");
script.type = "text\/javascript";
script.charset = "UTF-8";
script.async = "async";
script.defer = "defer";
script.src = ("https:" == document.location.protocol ? "https"
: "http")
+
"://tck.elitrack.com/tag?page=category&aid="+elitrack_client_ids+"&cid="+user_id+"&catId="+category_id;
document.getElementsByTagName("head")[0].appendChild(script);
})();
</script>
{/literal}