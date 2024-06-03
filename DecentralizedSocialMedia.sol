// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedSocialMedia {
    struct Post {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(uint256 => Post) public posts;
    mapping(address => uint256[]) public userPosts;
    mapping(uint256 => mapping(address => bool)) public postLikes;

    uint256 public postCount;

    event PostCreated(uint256 postId, address author, string content, uint256 timestamp);
    event PostLiked(uint256 postId, address liker);

    function createPost(string memory content) external {
        postCount++;
        posts[postCount] = Post(msg.sender, content, block.timestamp, 0);
        userPosts[msg.sender].push(postCount);
        emit PostCreated(postCount, msg.sender, content, block.timestamp);
    }

    function likePost(uint256 postId) external {
        require(posts[postId].author != address(0), "Post does not exist");
        require(!postLikes[postId][msg.sender], "Already liked");

        postLikes[postId][msg.sender] = true;
        posts[postId].likes++;
        emit PostLiked(postId, msg.sender);
    }

    function getUserPosts(address user) external view returns (uint256[] memory) {
        return userPosts[user];
    }

    function getPost(uint256 postId) external view returns (address author, string memory content, uint256 timestamp, uint256 likes) {
        Post storage post = posts[postId];
        return (post.author, post.content, post.timestamp, post.likes);
    }
}
