$(function(){
    var Post = Backbone.Model.extend({
	defaults: function() {
	    return {
		content: "no content",
		title: "no title",
		tags: [],
	    };
	},
	
	sync: function(method, model) {
	    var username = $("#username").val()
	    var password = $("#password").val()
	    var json = JSON.stringify(model);
	    if(method == "create"){
		$.ajax({
		    method: "POST",
		    url: "___BLOG_UI_POSTW_URL___",
		    data: json,
		    processData: false,
		    contentType: "application/json",
		    error: function(msg, status, error){
			if(status == 401){
			    alert("Auth error; please check credentials");
			}
			else{
			    alert("An error has occurred: " + JSON.stringify(msg) + " " + status + " " + error);
			}
		    },
		    beforeSend: function (xhr) {
			xhr.setRequestHeader ("Authorization", "Basic " + btoa(username + ":" + password));
		    },
		})
		    .done(function( msg ) {
			model.set('id', msg["id"]);
			alert( "Data Saved: " + JSON.stringify(msg) );
		    });
	    } else if(method == "delete"){
		$.ajax({
		    method: "DELETE",
		    url: "___BLOG_UI_POSTW_URL___",
		    data: json,
		    processData: false,
		    contentType: "application/json",
		    error: function(msg, status, error){
			if(status == 401){
			    alert("Auth error; please check credentials");
			}
			else{
			    alert("An error has occurred: " + JSON.stringify(msg) + " " + status + " " + error);
			}
		    },
		    beforeSend: function (xhr) {
			xhr.setRequestHeader ("Authorization", "Basic " + btoa(username + ":" + password));
		    },
		})
		    .done(function( msg ) {
			alert( "Deleted: " + JSON.stringify(msg) );
		    });
	    }
	    //alert(method + ": " + JSON.stringify(model));
	    //model.set('id', 0);
	}
    });

    var PostList = Backbone.Collection.extend({
	model: Post,
	url: "___BLOG_UI_POST_URL___",
	parse: function(response) {
	    return response.posts;
	},
	byTag: function(tag) {
            filtered = this.filter(function(post) {
		return post.attributes.tags.indexOf(tag) !== -1;
            });
	    return filtered;
	}
    });

    var Posts = new PostList;

    var PostSummaryView = Backbone.View.extend({

	tagName: "li",
	template: _.template($('#post-summary-template').html()),

	events: {},
	initialize: function() {},

	render: function(){
	    this.$el.html(this.template(this.model.toJSON()));
	    return this;
	},
	render_from_json: function(json){
	    this.$el.html(this.template(json));
	    return this;
	},

    });

    var PostFullView = Backbone.View.extend({
	tagName: "div",
	template: _.template($('#post-full-template').html()),

	events: {},
	initialize:function() {},

	render: function(){
	    var json = this.model.toJSON();
	    json["content"] = json["content"].replace(/\n/g, "<br />");
	    this.$el.html(this.template(json));
	    return this;
	},
	
    });

    var AppView = Backbone.View.extend({
	el: $("#blogapp"),
	collection: Posts,
	
	current_page: 1,
	events: {
	    "click #load-more": "load_next_page",
	    "click #create-button": "create",
	    "click #delete-button": "destroy",
	},
	
	initialize: function(){
	    this.listenTo(Posts, 'add', this.addOne);
	    this.listenTo(Posts, 'reset', this.render_all);
	    Posts.fetch({success: function(){
		if(!Backbone.History.started){
		    Backbone.history.start();
		}
	    }
			});
	},

	load_next_page: function(){
	    this.current_page += 1;
	    Posts.fetch({ add: true, remove: false, merge: false, data: {page: this.current_page}});
	},
	
	addOne: function(post_model){
	    var view = new PostSummaryView({model: post_model})
	    this.$("#post-list").append(view.render().el);
	},

	render_list: function(posts) {
	    $("#post-list").empty();
	    _.each(posts, function(element, index, list){
		var view = new PostSummaryView({model: element})
		this.$("#post-list").append(view.render().el);
	    });
	},
    
	render_tag:function(tag_name) {
	    this.render_list(this.collection.byTag(tag_name.trim()));
	},

	render_all:function() {
	    this.render_list(this.collection.models)
	},

	create: function(){
	    var title = $("#create-title").val();
	    var content = $("#create-content").val();
	    var tags = $("#create-tags").val().split(",").map(function(item) {
		return item.trim();
	    });
	    var new_post = new Post({"title": title, "content": content, "tags": tags});
	    new_post.save();
	},

	destroy: function(){
	    var id = $("#delete-id").val();
	    var post = Posts.get(id);
	    if(post){
		post.destroy({wait:true});
	    }
	    else{
		alert("Post with that id not found!")
	    }
	},

    });

    var App = new AppView;

    var AppRouter = Backbone.Router.extend({
	routes: {
	    "": "home",
	    "#/": "home",
	    "post/:post_id": "display_post",
	    "tag/:tag_name": "display_tag",
	    "admin": "admin",
	},

	hide_all: function(){
	    $("#post-full").hide();
	    $("#post-list-container").hide();
	    $("#admin").hide();
	},
	
	home: function(){
	    this.hide_all();
	    App.render_all();
	    $("#post-list-container").show();
	},

	display_post: function(post_id) {
	    this.hide_all();
	    var view = new PostFullView({model: Posts.get(post_id)})
	    $("#post-full").html(view.render().el);
	    $("#post-full").show();
	},

	display_tag: function(tag_name) {
	    this.hide_all();
	    App.render_tag(tag_name);
	    $("#post-list-container").show();
	},

	admin: function(){
	    this.hide_all();
	    $("#admin").show();
	}
	
    });

    var appRouter = new AppRouter();
});

				   
	
	
	    
