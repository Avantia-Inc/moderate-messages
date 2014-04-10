<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib"%>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib"%>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="uiComponents"
	uri="http://www.jahia.org/tags/uiComponentsLib"%>
<%@ taglib prefix="query" uri="http://www.jahia.org/tags/queryLib"%>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<template:addResources type="css" resources="moderateMessages.css" />
<template:addResources type="javascript" resources="jquery.min.js,jquery-ui.min.js,jquery.blockUI.js,workInProgress.js,admin-bootstrap.js,jquery.dataTables.min.js" />
<template:addResources type="css" resources="admin-bootstrap.css,bootstrap.min.css" />
<template:addResources type="css" resources="jquery-ui.smoothness.css,jquery-ui.smoothness-jahia.css" />


<c:set var="site" value="${renderContext.mainResource.node.resolveSite}"/>

<h2><fmt:message key="siteSettings.label.moderateMessages"/> - ${fn:escapeXml(site.displayableName)}</h2>

    <div class="box-1">
    <h3><fmt:message key="siteSettings.label.moderateForumMessages"/></h3>

    <c:choose>
    	<c:when test="${not empty forumPostlist}">
        <div class="container">
        <table id="forumMessagesTable" class="table table-bordered table-striped table-hover dataTable">
            <thead>
                <tr>
                    <th width="3%">#</th>
                    <th width="45%"><fmt:message key="moderateMessages.table.post" /></th>
                    <th width="10%"><fmt:message key="moderateMessages.table.postdate" /></th>
                    <th width="8%"><fmt:message key="moderateMessages.table.postby" /></th>
                    <th width="34%"><fmt:message key="moderateMessages.table.postactions" /></th>
                </tr>
            </thead>
            <tbody>

            <c:forEach items="${forumPostlist}" var="forumPost" varStatus="status">

              <template:addCacheDependency node="${forumPost}" />

              <c:if test="${jcr:isNodeType(forumPost, 'jnt:post')}">

               	<jcr:nodeProperty node="${forumPost}" name="jcr:title" var="commentTitle" />
              	<jcr:nodeProperty node="${forumPost.parent}" name="topicSubject" var="topicSubject" />
              	<jcr:nodeProperty node="${forumPost.parent.parent}" name="jcr:title" var="sectionTitle" />
              	<jcr:nodeProperty node="${forumPost}" name="jcr:createdBy" var="createdBy" />
                <jcr:nodeProperty node="${forumPost}" name="content" var="content" />

              	<c:if test="${jcr:hasPermission(forumPost, 'deletePost') and jcr:isNodeType(forumPost, 'jmix:moderated') and not forumPost.properties.moderated.boolean}">
              		<template:tokenizedForm>
              			<form
              				action="<c:url value='${url.baseLive}${forumPost.path}'/>"
              				method="post" id="jahia-forum-post-delete-${forumPost.UUID}">
              				<input type="hidden" name="jcrRedirectTo"
              					value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>" />
              				<%-- Define the output format for the newly created node by default html or by redirectTo--%>
              				<input type="hidden" name="jcrNewNodeOutputFormat" value="" />
              				<input type="hidden" name="jcrMethodToCall" value="delete" />
              			</form>
              		</template:tokenizedForm>
              	</c:if>

              	<c:if test="${jcr:hasPermission(forumPost.parent.parent, 'moderatePost') and jcr:isNodeType(forumPost, 'jmix:moderated') and not forumPost.properties.moderated.boolean}">
              		<template:tokenizedForm>
              			<form
              				action="<c:url value='${url.baseLive}${forumPost.path}'/>"
              				method="post"
              				id="jahia-forum-post-moderate-${forumPost.UUID}">
              				<input type="hidden" name="jcrRedirectTo"
              					value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>" />
              				<%-- Define the output format for the newly created node by default html or by redirectTo--%>
              				<input type="hidden" name="jcrNewNodeOutputFormat" value="" />
              				<input type="hidden" name="jcrMethodToCall" value="put" />
              				<input type="hidden" name="moderated" value="true" />
              			</form>
              		</template:tokenizedForm>
              	</c:if>

              	<c:if test="${jcr:hasPermission(forumPost.parent.parent, 'moderatePost') and jcr:isNodeType(forumPost, 'jmix:moderated') and not forumPost.properties.moderated.boolean}">
              	    <script>
                          $(window)
                            .load(function () {
                              $(".btn-${forumPost.UUID}")
                                .click(function () {
                                  if ($("#collapseme-${forumPost.UUID}")
                                    .hasClass("out")) {
                                    $("#collapseme-${forumPost.UUID}")
                                      .addClass("in");
                                    $("#collapseme-${forumPost.UUID}")
                                      .removeClass("out");
                                    $('.btn-${forumPost.UUID} span')
                                      .text('<fmt:message key="moderateMessages.closePost"/>');
                                  } else {
                                    $("#collapseme-${forumPost.UUID}")
                                      .addClass("out");
                                    $("#collapseme-${forumPost.UUID}")
                                      .removeClass("in");
                                    $('.btn-${forumPost.UUID} span')
                                      .text('<fmt:message key="moderateMessages.viewPost"/>');
                                  }
                                });
                            });
                      </script>
              		<tr>

              			<td><c:set var="count" value="${count + 1}" scope="page" />
              				<c:out value="${count}" /></td>
              			<td><a
              				href="${url.baseLive}${forumPost.parent.path}.html"
              				target="_blank"
              				title='<fmt:message key=" label.navigateTo "/>'> <c:out
              						value="${commentTitle.string}" />
              			</a> <br /> <i>Section: <c:out
              						value="${sectionTitle.string}" /> / Topic: <c:out
              						value="${topicSubject.string}" /></i> <br /></td>
              			<jcr:nodeProperty node="${forumPost}" name="jcr:lastModified"
              				var="lastModified" />
              			<td><span class="docspacedate timestamp"><fmt:formatDate
              						value="${lastModified.time}" pattern="yyyy/MM/dd HH:mm" /></span>
              			</td>
              			<td>
              			    <span class="author">
              			        <c:if test="${createdBy.string ne 'guest'}">
              						<a href="<c:url value='${url.base}${functions:lookupUser(createdBy.string).localPath}.html'/>">${createdBy.string}</a>
              						<jcr:node var="userNode" path="${functions:lookupUser(createdBy.string).localPath}" />
                                        <c:forEach items="${userNode.properties}" var="property">
                                            <c:if test="${property.name == 'j:firstName'}">
                                                <c:set var="firstname" value="${property.string}" />
                                            </c:if>
                                            <c:if test="${property.name == 'j:lastName'}">
                                                <c:set var="lastname" value="${property.string}" />
                                            </c:if>
                                            <c:if test="${property.name == 'j:email'}">
                                                <c:set var="email" value="${property.string}" />
                                            </c:if>
                                            <c:if test="${property.name == 'j:title'}">
                                                <c:set var="title" value="${property.string}" />
                                            </c:if>
                                        </c:forEach>
                                        <br />
                                        <i>(${firstname}<br/>${lastname})</i>
              					</c:if>
              					<c:if test="${createdBy.string eq 'guest'}">
              					    ${fn:escapeXml(forumPost.properties.pseudo.string)}
              					    <br />
                                    <i>(guest)</i>
              					</c:if>
              			    </span>
              			</td>
              			<td>
              			    <c:if test="${jcr:hasPermission(forumPost.parent.parent, 'moderatePost') and jcr:isNodeType(forumPost, 'jmix:moderated') and not forumPost.properties.moderated.boolean}">
              					<button type="button" class="btn btn-success"
              						onclick="document.getElementById('jahia-forum-post-moderate-${forumPost.UUID}').submit(); return false;">
              						<i class="icon-ok icon-white"></i><fmt:message key='moderateMessages.moderatePost' />
              					</button>
              				</c:if> <c:if test="${jcr:hasPermission(forumPost, 'deletePost')}">
              					<fmt:message key="moderateMessages.confirmDeletePost" var="confirmMsg" />
              					<button type="button" class="btn btn-danger"
              						onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                                        { document.getElementById("jahia-forum-post-delete-${forumPost.UUID}").submit(); } return false;'>
                                    <i class="icon-remove icon-white"></i><fmt:message key='moderateMessages.deletePost' />
              					</button>
              				</c:if>

              				<button type="button"
              					class="btn btn-primary btn-${forumPost.UUID}"
              					id="btn-${forumPost.UUID}" valign="middle" align="center">
                                <i class="icon-info-sign icon-white"></i><span><fmt:message key="moderateMessages.viewPost" /></span>
              				</button></td>

              		</tr>
              		<tr>
              			<td colspan="5"><div id="collapseme-${forumPost.UUID}"
              					class="collapse2 out">${functions:removeHtmlTags(content.string)}</div></td>
              		</tr>
              	</c:if>
              </c:if>
            </c:forEach>
            </tbody>
        </table>
        </div>
        	</c:when>
        	<c:otherwise>
        		<h3 class="noPostsToModerate">
        			<fmt:message key="moderateMessages.noPostToModerate" />
        		</h3>
        	</c:otherwise>
        </c:choose>
    </div>

         <c:set var="count" value="0" scope="page" />
        <div class="box-1">
            <h3><fmt:message key="siteSettings.label.moderateCommentMessages"/></h3>
                <c:choose>
                	<c:when test="${not empty CommentPostlist}">
                <table class="table table-bordered table-striped table-hover">
                    <thead>
                        <tr>
                            <th width="3%">#</th>
                            <th width="45%"><fmt:message key="moderateMessages.table.post" /></th>
                            <th width="10%"><fmt:message key="moderateMessages.table.postdate" /></th>
                            <th width="8%"><fmt:message key="moderateMessages.table.postby" /></th>
                            <th width="34%"><fmt:message key="moderateMessages.table.postactions" /></th>
                        </tr>
                    </thead>
                    <tbody>

                    <c:forEach items="${CommentPostlist}" var="commentPost" varStatus="status">


                      <template:addCacheDependency node="${commentPost}" />

                      <c:if test="${jcr:isNodeType(commentPost, 'jnt:post') && jcr:hasPermission(commentPost, 'deletePost')}">

                       	<jcr:nodeProperty node="${commentPost}" name="jcr:title" var="commentTitle" />
                      	<jcr:nodeProperty node="${commentPost.parent}" name="topicSubject" var="topicSubject" />
                      	<jcr:nodeProperty node="${commentPost.parent.parent}" name="jcr:title" var="sectionTitle" />
                      	<jcr:nodeProperty node="${commentPost}" name="jcr:createdBy" var="createdBy" />
                        <jcr:nodeProperty node="${commentPost}" name="content" var="content" />

                      <script>
                          $(window)
                            .load(function () {
                              $(".btn-${commentPost.UUID}")
                                .click(function () {
                                  if ($("#collapseme-${commentPost.UUID}")
                                    .hasClass("out")) {
                                    $("#collapseme-${commentPost.UUID}")
                                      .addClass("in");
                                    $("#collapseme-${commentPost.UUID}")
                                      .removeClass("out");
                                    $('.btn-${commentPost.UUID} span')
                                      .text('<fmt:message key="moderateMessages.closePost"/>');
                                  } else {
                                    $("#collapseme-${commentPost.UUID}")
                                      .addClass("out");
                                    $("#collapseme-${commentPost.UUID}")
                                      .removeClass("in");
                                    $('.btn-${commentPost.UUID} span')
                                      .text('<fmt:message key="moderateMessages.viewPost"/>');
                                  }
                                });
                            });
                      </script>



                      		<template:tokenizedForm>
                      			<form
                      				action="<c:url value='${url.baseLive}${commentPost.path}'/>"
                      				method="post" id="jahia-forum-post-delete-${commentPost.UUID}">
                      				<input type="hidden" name="jcrRedirectTo"
                      					value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>" />
                      				<%-- Define the output format for the newly created node by default html or by redirectTo--%>
                      				<input type="hidden" name="jcrNewNodeOutputFormat" value="" />
                      				<input type="hidden" name="jcrMethodToCall" value="delete" />
                      			</form>
                      		</template:tokenizedForm>





                      		<tr>

                      			<td><c:set var="count" value="${count + 1}" scope="page" />
                      				<c:out value="${count}" /></td>
                      			<td><a
                      				href="${url.baseLive}${commentPost.parent.parent.path}.html"
                      				target="_blank"
                      				title='<fmt:message key=" label.navigateTo "/>'> <c:out
                      						value="${commentTitle.string}" />
                      			</a> <br /> <i>Page: <c:out
                      						value="${sectionTitle.string}" /></i> <br /></td>
                      			<jcr:nodeProperty node="${commentPost}" name="jcr:lastModified" var="lastModified" />
                      			<td><span class="docspacedate timestamp">
                      			    <fmt:formatDate value="${lastModified.time}" pattern="yyyy/MM/dd HH:mm" /></span>
                      			</td>
                      			<td><span class="author">
                      			    <c:if test="${createdBy.string ne 'guest'}">
                      						<a href="<c:url value='${url.base}${functions:lookupUser(createdBy.string).localPath}.html'/>">${createdBy.string}</a>
                      						<jcr:node var="userNode" path="${functions:lookupUser(createdBy.string).localPath}" />
                                            <c:forEach items="${userNode.properties}" var="property">
                                                <c:if test="${property.name == 'j:firstName'}">
                                                    <c:set var="firstname" value="${property.string}" />
                                                </c:if>
                                                <c:if test="${property.name == 'j:lastName'}">
                                                    <c:set var="lastname" value="${property.string}" />
                                                </c:if>
                                                <c:if test="${property.name == 'j:email'}">
                                                    <c:set var="email" value="${property.string}" />
                                                </c:if>
                                                <c:if test="${property.name == 'j:title'}">
                                                    <c:set var="title" value="${property.string}" />

                                                </c:if>
                                            </c:forEach>
                                            <br />
                                            <i>(${firstname}<br/>${lastname})</i>
                      				</c:if>
                      				<c:if test="${createdBy.string eq 'guest'}">
                      				    ${fn:escapeXml(commentPost.properties.pseudo.string)}
                      				    <i>(guest)</i>
                      				</c:if>

                      			</span></td>
                      			<td>
                      			    <c:if test="${jcr:hasPermission(commentPost, 'deletePost')}">
                      					<fmt:message key="moderateMessages.confirmDeletePost" var="confirmMsg" />
                      					<button type="button" class="btn btn-danger"
                      						onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                      { document.getElementById("jahia-forum-post-delete-${commentPost.UUID}").submit(); } return false;'>
                                            <i class="icon-remove icon-white"></i><fmt:message key='moderateMessages.deletePost' />

                      					</button>
                      				</c:if>

                      				<button type="button"
                      					class="btn btn-primary btn-${commentPost.UUID}"
                      					id="btn-${commentPost.UUID}" valign="middle" align="center">
                                        <i class="icon-info-sign icon-white"></i><span><fmt:message key="moderateMessages.viewPost" /></span>

                      				</button></td>

                      		</tr>
                      		<tr>
                      			<td colspan="5"><div id="collapseme-${commentPost.UUID}"
                      					class="collapse2 out">${functions:removeHtmlTags(content.string)}</div></td>
                      		</tr>

                      </c:if>



                    </c:forEach>

                    </tbody>
                </table>
                	</c:when>
                	<c:otherwise>
                		<h3 class="noPostsToModerate">
                			<fmt:message key="moderateMessages.noPostToModerate" />
                		</h3>
                	</c:otherwise>
                </c:choose>
             </div>

            <c:set var="count" value="0" scope="page" />
                <div class="box-1">
                    <h3><fmt:message key="siteSettings.label.moderateBlogMessages"/></h3>
                    <c:choose>
                        <c:when test="${not empty blogPostlist}">
                        <table class="table table-bordered table-striped table-hover">
                            <thead>
                                <tr>
                                    <th width="3%">#</th>
                                    <th width="45%"><fmt:message key="moderateMessages.table.post" /></th>
                                    <th width="10%"><fmt:message key="moderateMessages.table.postdate" /></th>
                                    <th width="8%"><fmt:message key="moderateMessages.table.postby" /></th>
                                    <th width="34%"><fmt:message key="moderateMessages.table.postactions" /></th>
                                </tr>
                            </thead>
                            <tbody>

                            <c:forEach items="${blogPostlist}" var="blogPost" varStatus="status">


                              <template:addCacheDependency node="${blogPost}" />

                              <c:if test="${jcr:isNodeType(blogPost, 'jnt:post') && jcr:hasPermission(blogPost, 'deletePost')}">

                               	<jcr:nodeProperty node="${blogPost}" name="jcr:title" var="commentTitle" />
                              	<jcr:nodeProperty node="${blogPost.parent}" name="topicSubject" var="topicSubject" />
                              	<jcr:nodeProperty node="${blogPost.parent.parent}" name="jcr:title" var="sectionTitle" />
                              	<jcr:nodeProperty node="${blogPost}" name="jcr:createdBy" var="createdBy" />
                                <jcr:nodeProperty node="${blogPost}" name="content" var="content" />

                              <script>
                                  $(window)
                                    .load(function () {
                                      $(".btn-${blogPost.UUID}")
                                        .click(function () {
                                          if ($("#collapseme-${blogPost.UUID}")
                                            .hasClass("out")) {
                                            $("#collapseme-${blogPost.UUID}")
                                              .addClass("in");
                                            $("#collapseme-${blogPost.UUID}")
                                              .removeClass("out");
                                            $('.btn-${blogPost.UUID} span')
                                              .text('<fmt:message key="moderateMessages.closePost"/>');
                                          } else {
                                            $("#collapseme-${blogPost.UUID}")
                                              .addClass("out");
                                            $("#collapseme-${blogPost.UUID}")
                                              .removeClass("in");
                                            $('.btn-${blogPost.UUID} span')
                                              .text('<fmt:message key="moderateMessages.viewPost"/>');
                                          }
                                        });
                                    });
                              </script>



                              		<template:tokenizedForm>
                              			<form
                              				action="<c:url value='${url.baseLive}${blogPost.path}'/>"
                              				method="post" id="jahia-forum-post-delete-${blogPost.UUID}">
                              				<input type="hidden" name="jcrRedirectTo"
                              					value="<c:url value='/cms/editframe/default/${currentResource.locale}${renderContext.mainResource.path}'/>" />
                              				<%-- Define the output format for the newly created node by default html or by redirectTo--%>
                              				<input type="hidden" name="jcrNewNodeOutputFormat" value="" />
                              				<input type="hidden" name="jcrMethodToCall" value="delete" />
                              			</form>
                              		</template:tokenizedForm>

                              		<tr>

                              			<td><c:set var="count" value="${count + 1}" scope="page" />
                              				<c:out value="${count}" /></td>
                              			<td><a
                              				href="${url.baseLive}${blogPost.parent.parent.path}.html"
                              				target="_blank"
                              				title='<fmt:message key=" label.navigateTo "/>'> <c:out
                              						value="${commentTitle.string}" />
                              			</a> <br /> <i>Blog: <c:out
                              						value="${sectionTitle.string}" /></i> <br /></td>
                              			<jcr:nodeProperty node="${blogPost}" name="jcr:lastModified"
                              				var="lastModified" />
                              			<td><span class="docspacedate timestamp"><fmt:formatDate
                              						value="${lastModified.time}" pattern="yyyy/MM/dd HH:mm" /></span>
                              			</td>
                              			<td><span class="author">
                              			    <c:if test="${createdBy.string ne 'guest'}">
                              					<a href="<c:url value='${url.base}${functions:lookupUser(createdBy.string).localPath}.html'/>">${createdBy.string}</a>
                              					<jcr:node var="userNode" path="${functions:lookupUser(createdBy.string).localPath}" />
                                                <c:forEach items="${userNode.properties}" var="property">
                                                    <c:if test="${property.name == 'j:firstName'}">
                                                        <c:set var="firstname" value="${property.string}" />
                                                    </c:if>
                                                    <c:if test="${property.name == 'j:lastName'}">
                                                        <c:set var="lastname" value="${property.string}" />
                                                    </c:if>
                                                    <c:if test="${property.name == 'j:email'}">
                                                        <c:set var="email" value="${property.string}" />
                                                    </c:if>
                                                    <c:if test="${property.name == 'j:title'}">
                                                        <c:set var="title" value="${property.string}" />

                                                    </c:if>
                                                </c:forEach>
                                                <br />
                                                <i>(${firstname}<br/>${lastname})</i>
                              				</c:if>
                              				<c:if test="${createdBy.string eq 'guest'}">
                              				    ${fn:escapeXml(blogPost.properties.pseudo.string)}
                              				</c:if>
                              			</span></td>
                              			<td>
                              			    <c:if test="${jcr:hasPermission(blogPost, 'deletePost')}">
                              					<fmt:message key="moderateMessages.confirmDeletePost" var="confirmMsg" />
                              					<button type="button" class="btn btn-danger"
                              						onclick='if (window.confirm("${functions:escapeJavaScript(confirmMsg)}"))
                              { document.getElementById("jahia-forum-post-delete-${blogPost.UUID}").submit(); } return false;'>
                                                    <i class="icon-remove icon-white"></i><fmt:message key='moderateMessages.deletePost' />

                              					</button>
                              				</c:if>

                              				<button type="button"
                              					class="btn btn-primary btn-${blogPost.UUID}"
                              					id="btn-${blogPost.UUID}" valign="middle" align="center">
                                                <i class="icon-info-sign icon-white"></i><span><fmt:message key="moderateMessages.viewPost" /></span>

                              				</button></td>

                              		</tr>
                              		<tr>
                              			<td colspan="5"><div id="collapseme-${blogPost.UUID}"
                              					class="collapse2 out">${functions:removeHtmlTags(content.string)}</div></td>
                              		</tr>

                              </c:if>
                            </c:forEach>
                            </tbody>
                        </table>
                         	</c:when>
                         	<c:otherwise>
                         		<h3 class="noPostsToModerate">
                         			<fmt:message key="moderateMessages.noPostToModerate" />
                         		</h3>
                         	</c:otherwise>
                         </c:choose>
                     </div>