$(function(){
    
    var Post = Backbone.Model.extend({
	defaults: function() {
	    return {
		id: 0,
		content: "no content",
		date: 0,
		title: "no title",
		tags: [],
	    };
	},

	//sync: function(method, model, options) {

	//}
    });

    var PostList = Backbone.Collection.extend({
	model: Post,
	url: 'http://localhost/cgi-bin/post.tcl',
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
	    this.$el.html(this.template(this.model.toJSON()));
	    return this;
	},
	
    });

    var AppView = Backbone.View.extend({
	el: $("#blogapp"),
	collection: Posts,
	
	current_page: 1,
	events: {
	    "click #load-more": "load_next_page",
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
	    this.render_list(this.collection.byTag(tag_name));
	},

	render_all:function() {
	    this.render_list(this.collection.models)
	},

	
	
    });

    var App = new AppView;

    var AppRouter = Backbone.Router.extend({
	routes: {
	    "": "home",
	    "#/": "home",
	    "post/:post_id": "display_post",
	    "tag/:tag_name": "display_tag",
	},

	home: function(){
	    App.render_all();
	    $("#post-full").hide();
	    $("#post-list").show();
	},

	display_post: function(post_id) {
	    var view = new PostFullView({model: Posts.get(post_id)})
	    $("#post-full").html(view.render().el);
	    $("#post-full").show();
	    $("#post-list").hide();
	},

	display_tag: function(tag_name) {
	    App.render_tag(tag_name);
	    $("#post-full").hide();
	    $("#post-list").show();
	}
	
    });

    var appRouter = new AppRouter();
});

				   
	
	
	    
