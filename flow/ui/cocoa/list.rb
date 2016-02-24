# module UI
#   class List < View
#     class CustomListCell < UITableViewCell
#       IDENTIFIER = "CustomListCell"
#
#       def add_child(child)
#         self.contentView.addSubview(child.container)
#         child.frame = self.contentView.bounds
#       end
#     end
#
#     def initialize
#       super
#       @data_source = []
#       container.registerClass(CustomListCell, forCellReuseIdentifier: CustomListCell::IDENTIFIER)
#     end
#
#     def container
#       @contaienr ||= proxies[:ui_table_view]
#     end
#
#     def numberOfSectionsInTableView(table_view)
#       1
#     end
#
#     def tableView(table_view, numberOfRowsInSection: section)
#       @data_source.count
#     end
#
#     def tableView(table_view, cellForRowAtIndexPath: index_path)
#       table_view.dequeueReusableCellWithIdentifier(CustomListCell::IDENTIFIER, forIndexPath: index_path)
#       content_view = @render_row_block.call(@data_source[index_path.row],
#                                             index_path.row,
#                                             index_path.section,
#                                             {ui_table_view_cell: cell})
#
#       cell.add_child(content_view)
#       cell
#     end
#
#     def data_source=(data_source)
#       @data_source = data_source
#       Task.main do
#         container.reloadData
#       end
#     end
#
#     def render_row(&block)
#       @render_row_block = block.weak!
#     end
#
#     def proxies
#       @proxies ||= build_proxies
#     end
#
#     def build_proxies
#       ui_table_view = UITableView.alloc.init
#       ui_table_view.delegate = self
#       ui_table_view.dataSource = self
#
#       {
#         ui_table_view: ui_table_view
#       }
#     end
#   end
# end
