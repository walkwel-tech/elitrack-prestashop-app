<?php   
if (!defined('_PS_VERSION_'))
  exit;

class elitrack extends Module {

	public function __construct() {
	    $this->name = 'elitrack';
	    $this->tab = 'advertising_marketing';
	    $this->version = '1.3.0';
	    $this->author = 'EliTrack Developers';
	    $this->need_instance = 1;

	    $this->bootstrap = true;
	    parent::__construct();
	 
	    $this->displayName = $this->l('Elitrack');
	    $this->description = $this->l('EliTrack Analytics');

	 
	    $this->confirmUninstall = $this->l('Are you sure you want to uninstall?');
	 
	    if (!Configuration::get('MYMODULE_NAME'))      
	      $this->warning = $this->l('No name provided');
  	}

  	public function install() {

  		if (!parent::install() || !Configuration::updateValue('MYMODULE_NAME', 'elitrack')) {
  			return false;
  		}
    	else {
    		return true;
    	}
  		
	}

	public function uninstall() {

  		if (!parent::uninstall() || !Configuration::deleteByName('MYMODULE_NAME') || !Configuration::deleteByName('client_key') || !Configuration::deleteByName('hash_enabled')) {
  			return false;
  		}
    	else {
    		return true;
    	}
  		
	}

	public function hookdisplayFooter($params)
    {
        $this->context->smarty->assign(
            array(
                'ELITRACK_CLIENT_ID' => Configuration::get('client_key'),
                'hash_enabled' => Configuration::get('hash_enabled'),
                'controller_name' => $this->context->controller->php_self,
            )
        );
        $this->context->controller->addJs($this->_path.'js/jquery.md5.js');

	    $_controller = $this->context->controller;
        // index page
        if (isset($_controller->php_self) && $_controller->php_self == 'index') {
            return $this->display(__FILE__, 'index_script.tpl');
        }
        // category page
	    if (isset($_controller->php_self) && $_controller->php_self == 'category') {
            return $this->display(__FILE__, 'category_script.tpl');
	    }
        // product page
        elseif(isset($_controller->php_self) && $_controller->php_self == 'product') {
            return $this->display(__FILE__, 'product_script.tpl');
        }
        //cart page
        elseif(isset($_controller->php_self) && $_controller->php_self == 'order' || $_controller->php_self == 'order-opc' || $_controller->php_self == 'cart') {
            return $this->display(__FILE__, 'cart_script.tpl');
        }
        // order confirm page
        elseif(isset($_controller->php_self) && $_controller->php_self == 'order-confirmation') {
            return $this->display(__FILE__, 'order_script.tpl');
        }

        // pagenot found
        elseif(isset($_controller->php_self) && $_controller->php_self == 'pagenotfound') {
            
        }
        // all other pages
        else {
            return $this->display(__FILE__, 'other_pages.tpl');
        }
        
    }


    public function getContent() {
        $output = null;
     
        if (Tools::isSubmit('submit'.$this->name)) {
            $client_key = strval(Tools::getValue('client_key'));
            $user_hash = strval(Tools::getValue('user_hash'));
            if (!$client_key || empty($client_key) || !Validate::isGenericName($client_key)) {
                $output .= $this->displayError($this->l('Invalid Client Public Key!!'));
            }  
            else {
                Configuration::updateValue('client_key', $client_key);
                Configuration::updateValue('hash_enabled', $user_hash);
                if($this->registerHook('displayFooter') == false) {
                    $this->registerHook('displayFooter');
                }
                $output .= $this->displayConfirmation($this->l('Settings updated'));
            }

        }
        $this->context->smarty->assign(array(
            'module_dir' => $this->_path,
        ));
        $logo = $this->context->smarty->fetch($this->local_path.'views/templates/admin/configure.tpl');
        return $output.$logo.$this->displayForm();
	}

	public function displayForm() {
        // Get default language
        $default_lang = (int)Configuration::get('PS_LANG_DEFAULT');
         
        // Init Fields form array
        $fields_form[0]['form'] = array(
            'legend' => array(
                'title' => $this->l('Elitrack Settings'),
            ),
            'input' => array(
                array(
                    'type' => 'text',
                    'label' => $this->l('Elitrack Client Public Key'),
                    'name' => 'client_key',
                    'size' => 25,
                    'required' => true
                ),
                array(
                    'type' => 'radio',
                    'label' => $this->l('Send User ID Hash'),
                    'name' => 'user_hash',
                    'required' => true,
                    'values'    => array(                                 
                        array(
                          'id'    => 'active_on',                 
                          'value' => 1,
                          'label' => $this->l('Enabled')
                        ),
                        array(
                          'id'    => 'active_off',
                          'value' => 0,
                          'label' => $this->l('Disabled')
                        )
                    )
                )
            ),
            'submit' => array(
                'title' => $this->l('Save'),
                'class' => 'btn btn-default pull-right'
            )
        );
         
        $helper = new HelperForm();
         
        // Module, token and currentIndex
        $helper->module = $this;
        $helper->name_controller = $this->name;
        $helper->token = Tools::getAdminTokenLite('AdminModules');
        $helper->currentIndex = AdminController::$currentIndex.'&configure='.$this->name;
         
        // Language
        $helper->default_form_language = $default_lang;
        $helper->allow_employee_form_lang = $default_lang;
         
        // Title and toolbar
        $helper->title = $this->displayName;
        $helper->show_toolbar = true;        // false -> remove toolbar
        $helper->toolbar_scroll = true;      // yes - > Toolbar is always visible on the top of the screen.
        $helper->submit_action = 'submit'.$this->name;
        $helper->toolbar_btn = array(
            'save' =>
            array(
                'desc' => $this->l('Save'),
                'href' => AdminController::$currentIndex.'&configure='.$this->name.'&save'.$this->name.
                '&token='.Tools::getAdminTokenLite('AdminModules'),
            ),
            'back' => array(
                'href' => AdminController::$currentIndex.'&token='.Tools::getAdminTokenLite('AdminModules'),
                'desc' => $this->l('Back to list')
            )
        );
         
         //Load current value
        $helper->fields_value['client_key'] = Configuration::get('client_key');
        $helper->fields_value['user_hash'] = Configuration::get('hash_enabled');
         
        return $helper->generateForm($fields_form);
    }

}

?>