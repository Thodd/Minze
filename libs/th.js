(function(window) {

        //jquery like interface
		var th = function(query){
			var queryType = typeof(query),
				queryResult;
			
			if(queryType === "string"){
				queryResult = document.querySelectorAll(query);
				if(queryResult){
					if(queryResult.length > 1){
						this.DOM = queryResult;
					}else if (queryResult.length === 1){
						this.DOM = queryResult[0];
					}else{
						console.warn("No element for the query selector '" + query + "' could be found!");
					}
				}
			}else{
                //in case the given argument 'query' is a DOM element
                //TODO: Check if 'query' really is a dom node(list)
				this.DOM = query;
			}
			
			return this;
		};
		
		th.prototype = proto = { };
		
		proto.addClass = function(className){
			this.removeClass(className);
			this.DOM.className += (" " + className);
			return this;
		};
		proto.removeClass = function(className){
			this.DOM.className = this.DOM.className.replace(className, "");
			this.DOM.className = this.DOM.className.trim();
			return this;
		};
		proto.toggleClass = function(className){
			if(this.DOM.className.indexOf(className) != -1){
				this.removeClass(className);
			}else{
				this.addClass(className);
			}
		};
		
		proto.display = function(value){
			this.DOM.style.display = value;
			return this;
		};
		proto.show = function(){
			this.display("");
			return this;
		};
		proto.hide = function(){
			this.display("none");
			return this;
		};

        //execute a function 'fn' on each element in this.DOM
        //'bind' maybe another object to which the function 'fn' is bound
		proto.each = function(fn, bind){
			var i = this.DOM.length || 1,
				elemList = this.DOM,
				domElem;
			
            //if this.DOM is only 1 element, create a pseudo-array
			if(i === 1){
				elemList = [this.DOM];
			}
			
			//iterate this.DOM and (LAZY) wrap every item as an "th item"
			while (i--) {
				domElem = this.DOM[i];
				fn.call(bind || domElem, domElem);
			}
				
			return this;
		};
		

		window.th = function(query){
			return new th(query);
		};
		
		//shortcut to document ready
		window.th.ready = function(callback) {
			document.onreadystatechange = function() {
				if (document.readyState === 'complete') {
					callback.call();
				}
			};
		};
		
		//filling possible holes with debugging logs/warnings (firefox and ie)
		window.console = window.console || {};
		window.console.log = window.console.log || function(){};
		window.console.warn = window.console.warn || function(){}; 
		
}(window));