
{addJsDef ELITRACK_CLIENT_ID=$ELITRACK_CLIENT_ID|escape:'html':'UTF-8'}
{addJsDef hash_enabled=$hash_enabled|escape:'html':'UTF-8'}
{addJsDef controller_name=$controller_name|escape:'html':'UTF-8'}

{literal}

<script>
// cart page
var prod_id = "";
var unit_price = "";
var total_price = "";
var products = "";
var gtotal = 0;
</script>
{/literal}{foreach $products as $product}{literal}
<script>
prod_id = '{/literal}{$product.id_product}{literal}';
total_price = Math.round('{/literal}{$product.total_wt}{literal}' * 100) / 100;
unit_price = Math.round('{/literal}{$product.price_wt}{literal}' * 100) / 100;
products += prod_id+':'+total_price+':'+unit_price+';';
gtotal += total_price;
</script>
{/literal}{/foreach}{literal}

<script type="text/javascript">
var pagename = '{/literal}{$controller_name}{literal}';
var elitrack_client_ids = '{/literal}{$ELITRACK_CLIENT_ID}{literal}';
var user_id = '{/literal}{$cookie->id_customer}{literal}';
products = products.slice(0, -1);
var grand_total = Math.round(gtotal * 100) / 100;
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
if(products == "") {
	return false;
}
var script = document.createElement("script");
script.type = "text\/javascript";
script.charset = "UTF-8";
script.async = "async";
script.defer = "defer";
script.src = ("https:" == document.location.protocol ? "https"
: "http")
+
"://tck.elitrack.com/tag?page=cart&aid="+elitrack_client_ids+"&cid="+user_id+"&products="+products+"&totalPrice="+grand_total;
document.getElementsByTagName("head")[0].appendChild(script);
})();
</script>
{/literal}