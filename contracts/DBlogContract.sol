// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

struct BlogPost {
    bool exists;
    uint postNum;
    string title;
    string content;
    string[] tags;
    uint likeCount;
    bool isDeleted;
}

import "./DBlogPostContract.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DBlogContract is Ownable {
    
    string public blogName;
    
    uint postCount;
    uint tagCount;
    
    // TODO is this needed or is address fine
    mapping(uint => DBlogPostContract) public postMap;
    mapping(uint => string) public tagNames;
    
    // required for ui to iterate through page names for given tag
    mapping(string => mapping(uint => address)) public tagPageMap;
    mapping(string => uint) public tagPageCounts;
    mapping(string => bool) public tagExistence;
    
    constructor(string memory _blogName) public {
        blogName = _blogName;
        postCount = 0;
        tagCount = 0;
    }
    
    function publishBlogPost(string memory _postTitle, 
        string memory _postContent, 
        string[] memory _tags,
        bool _commentsEnabled) onlyOwner public returns(uint postNum)  {
        
        // TODO handle duplicate tags passed
        postCount++;
        postMap[postCount] = new DBlogPostContract(address(this), postCount, _postTitle, _postContent, _tags, _commentsEnabled);
        
        for(uint i = 0; i < _tags.length; i++) {
            string memory lowercaseTagName = _tags[i];
            
            if (!tagExistence[lowercaseTagName]) {
                tagExistence[lowercaseTagName] = true;
                tagNames[tagCount++] = lowercaseTagName;
                tagPageCounts[lowercaseTagName] = 1;
            }
            else {
                tagPageCounts[lowercaseTagName]++;
            }
            
            tagPageMap[lowercaseTagName][tagPageCounts[lowercaseTagName] - 1] = address(postMap[postCount]);
        }
        
        return postCount;
    }
    
    function deleteBlogPost(uint _postNum) public {
        // must be owner
        
        // if (postMap[_postNum]) {
        //     postMap[_postNum].isDeleted = true;
        // }
        
        // todo delete tag if no posts 
    }
    
}